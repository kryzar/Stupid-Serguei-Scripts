#!/bin/zsh
# Angif.zsh
# Antoine Hugounet
# exemple d'utilisation : angif "https://www.youtube.com/watch?v=mO6HyNj8Owk" 2 5
# cet exemple fait un gif de 5 s à partir de 2 s dans la vidéo

# default parameters
fps=10				# default is 10 fps but can be changed with -f/--fps
width=700			# default is 700 px but can be changed with -w/--width

# aller au dossier de travail
cd ~/Downloads

# parsing options (thanks to Florian)
# https://medium.com/@Drew_Stokes/bash-argument-parsing-54f3b81a6a8f
args=()
while (( $# )); do
	case $1 in
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
			args+=($1)
			shift
			;;
	esac
done

# get mandatory positional arguments
lien_youtube=$args[1]
debut_extrait=$args[2]
duree_extrait=$args[3]

# récupérer le nom de la vidéo
nom_video=$(youtube-dl --get-filename $lien_youtube)
extension="${nom_video##*.}"
outfile_racine_nom="${nom_video%.*}-${debut_extrait}-${duree_extrait}"
outfile_video="${outfile_racine_nom}.${extension}"
outfile_gif="${outfile_racine_nom}.gif"

# voir le commentaire de JaySandhu du 06-12-2015
# https://github.com/ytdl-org/youtube-dl/issues/622
# pour convertir une vidéo en gif avec ffmpeg, voir ça
# https://superuser.com/questions/556029/how-do-i-convert-a-video-to-gif-using-ffmpeg-with-reasonable-quality
# -an is to get rid of the audio
# https://superuser.com/questions/268985/remove-audio-from-video-file-with-ffmpeg
url=$(youtube-dl -f best --get-url $lien_youtube)
ffmpeg -ss $debut_extrait -i $url -t $duree_extrait -an -c:v copy $outfile_video
ffmpeg -i $outfile_video -vf "fps=${fps},scale=${width}:-1" $outfile_gif

# remove video
rm $outfile_video
