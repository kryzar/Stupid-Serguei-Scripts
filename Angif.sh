#!/bin/zsh
# Angif.sh
: '
Copyright (C) 2020 Antoine Hugounet

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>.
'

# help message
# to echo bold, see 
# https://stackoverflow.com/questions/2924697/how-does-one-output-bold-text-in-bash
bold=$(tput bold)
normal=$(tput sgr0)
help_message_begining="${bold}Angif${normal}
Given a YouTube video url, a begining time and a duration time, Angif creates a gif of the video from the begining time and of the duration time you gave it. See options below.

${bold}Usage${normal}
angif [-h/--help]
angif <url> <extract begining> <extract duration> [options]\n"

help_message_options="-h/--help	display this message
-d/--directory <dir>	create the gif in the specified <dir> directory
-f/--fps <val>	choose the number of fps in the gif, default is 10 fps
-w/--width <val>	choose the width (in px) of the gif, default is 700 px \n"

help_message_end="${bold}Examples${normal}
$ angif \"https://www.youtube.com/watch?v=dQw4w9WgXcQ\" 0:43 8
This will create a 8 seconds gif from 0:43 seconds in the video, where the script is.
$ angif \"https://www.youtube.com/watch?v=dQw4w9WgXcQ\" 0:43 8 --dir ~/Downloads
This will do the same, except that the gif is created in ~/Downloads.

${bold}Warnings${normal}
Depending on your OS, you may need not to use marks for the YouTube url. 

Made by Antoine Hugounet. This work is under license GNU General Public License v3.0.
If you want, please contribute or help by contacting me or making a pull request : https://github.com/kryzar/Stupid-Serguei-Scripts."

function print_help_message () {
	echo $help_message_begining
	echo ${bold}Options${normal}
	echo $help_message_options | column -ts $'\t'
	echo
	echo $help_message_end
}

# default parameters
fps=10		# default is 10 fps but can be changed with -f/--fps
width=700	# default is 700 px but can be changed with -w/--width

# parsing options (thanks to Florian)
if [[ $# == 0 || $1 == "-h" || $1 == "--help" ]]; then
	print_help_message
else
	while [ $# -ge 1 ]; do
		case $1 in
			# boolean options
			-h|--help)
				print_help_message 
				shift
				;;
			# options with arguments
			-d|--directory)
				if [ -n $2 ] && [ ${2:0:1} != "-" ]; then
					cd $2
					shift 2
				else
					echo "Error: argument for $1 is missing." >&2
					exit 1
				fi
				;;
			-f|--fps)
				if [ -n $2 ] && [ ${2:0:1} != "-" ]; then
					fps=$2
					shift 2
				else
					echo "Error: argument for $1 is missing." >&2
					exit 1
				fi
				;;
			-w|--width)
				if [ -n $2 ] && [ ${2:0:1} != "-" ]; then
					width=$2
					shift 2
				else
					echo "Error: argument for $1 is missing." >&2
					exit 1
				fi
				;;
			# 
			-*|--*=) # unsupported flags
				echo "Error: unsupported option $1." >&2
				exit 1
				;;
			*) # preserve positional arguments
				mandatory_args+=($1)
				shift
				;;
		esac
	done

	# get mandatory positional arguments
	link_youtube=$mandatory_args[1]
	extract_begining=$mandatory_args[2]
	extract_duration=$mandatory_args[3]

	# get video name and prepare various output file names
	video_name=$(youtube-dl --get-filename $link_youtube)
	extension="${video_name##*.}"
	outfile_name_root="${video_name%.*}-${extract_begining}-${extract_duration}"
	outfile_video="${outfile_name_root}.${extension}"
	outfile_gif="${outfile_name_root}.gif"

	# this is where the fun begins
	# instead of downloading the full video and cropping it after,
	# we use youtube-dl --get-url to create a download url understable by ffmpeg
	# we give it to ffmpeg in -i $url and thanks to -ss and -t,
	# ffmpeg is then able to download only the desired extract of the video
	# for more information, see JaySandhu's comment from 2015 December 06
	# https://github.com/ytdl-org/youtube-dl/issues/622
	#
	# to convert a video to a gif using ffmpeg, see
	# https://superuser.com/questions/556029/how-do-i-convert-a-video-to-gif-using-ffmpeg-with-reasonable-quality
	#
	# -an is to get rid of the audio, see
	# https://superuser.com/questions/268985/remove-audio-from-video-file-with-ffmpeg
	url=$(youtube-dl -f best --get-url $link_youtube)
	ffmpeg -ss $extract_begining -i $url -t $extract_duration -an -c:v copy $outfile_video
	ffmpeg -i $outfile_video -vf "fps=${fps},scale=${width}:-1" $outfile_gif

	# remove video
	rm $outfile_video
fi
