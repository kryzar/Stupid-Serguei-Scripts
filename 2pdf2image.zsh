#!/bin/zsh
# This script compiles the pdf given as an argument
# and creates an image of the pdf.
# The two pages are concatenated horizontally.
# They are separated by a 2px black line.
# There is a shadow surrounding the image for better visibility.

name_root="${1%.*}"
outfile="${name_root}.png"

# compile LaTeX
pdflatex $1

# convert each pdf page to an individual png image
# https://aleksandarjakovljevic.com/convert-pdf-images-using-imagemagick/
# https://stackoverflow.com/questions/2322750/replace-transparency-in-png-images-with-white-background
# This does not work with jpg files somehow. So I use -flatten.
# But if I do that I must do it at one page at a time. Fuck that.
convert -density 600 "$name_root.pdf[0]" -resize 2048x -quality 100 -flatten $name_root-0.png
convert -density 600 "$name_root.pdf[1]" -resize 2048x -quality 100 -flatten $name_root-1.png
# add a right border to the left image so that the two pages look separated
convert  $name_root-0.png -gravity east -background black -splice 1x0 $name_root-0.png
# concatenate horizontally the two images
convert $name_root-0.png $name_root-1.png +append $outfile
# add a black border
convert $outfile -bordercolor black -border 1x1 $outfile
# clean yourself up
rm $name_root-0.png
rm $name_root-1.png
