#!/bin/zsh
# Angif.zsh
# Antoine Hugounet
# exemple d'utilisation : angif "https://www.youtube.com/watch?v=mO6HyNj8Owk" 2 5
# cet exemple fait un gif de 5 s à partir de 2 s dans la vidéo

lien_youtube=$1
debut_extrait=$2	
duree_extrait=$3
fps=${4:-10}		# optionnel, 10 fps par défaut
largeur=${5:-700}	# optionnel, 700 px de large par défaut

# aller au dossier de travail
cd ~/Downloads

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
url=$(youtube-dl -f best --get-url $lien_youtube)
ffmpeg -ss $debut_extrait -i $url -t $duree_extrait -c:v copy $outfile_video
ffmpeg -i $outfile_video -vf "fps=${fps},scale=${largeur}:-1" $outfile_gif

rm $outfile_video
