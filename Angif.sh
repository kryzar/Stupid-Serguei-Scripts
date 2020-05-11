#!/bin/zsh
# Angif.sh
# Antoine Hugounet

# default parameters
fps=10		# default is 10 fps but can be changed with -f/--fps
width=700	# default is 700 px but can be changed with -w/--width

# parsing options (thanks to Florian)
# see https://medium.com/@Drew_Stokes/bash-argument-parsing-54f3b81a6a8f
mandatory_args=()
while [ $# -ge 1 ]; do
	case $1 in
		-d|--directory)
			if [ -n $2 ] && [ ${2:0:1} != "-" ]; then
				cd $2
				shift 2
			else
				echo "Error: Argument for $1 is missing" >&2
				exit 1
			fi
			;;
		-f|--fps)
			if [ -n $2 ] && [ ${2:0:1} != "-" ]; then
				fps=$2
				shift 2
			else
				echo "Error: Argument for $1 is missing" >&2
				exit 1
			fi
			;;
		-w|--width)
			if [ -n $2 ] && [ ${2:0:1} != "-" ]; then
				width=$2
				shift 2
			else
				echo "Error: Argument for $1 is missing" >&2
				exit 1
			fi
			;;
		-*|--*=) # unsupported flags
			echo "Error: Unsupported flag $1" >&2
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
