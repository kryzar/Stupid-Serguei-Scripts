# Angif

Given a YouTube video url, a begining time and a duration time, [Angif](Angif.sh) creates a gif of the video from the begining time and of the duration time you gave it. See options below.

[Angif](Angif.sh) comes as a single file zsh script.

## Usage

### Basic usage
```
angif [-h/--help]
angif <url> <extract begining> <extract duration> [options]\n"
```

### Options
```
-h/--help		display the help message
-d/--directory <dir>	create the gif in the specified <dir> directory
-f/--fps <val>		choose the number of fps in the gif, default is 10 fps
-w/--width <val>	choose the width (in px) of the gif, default is 700 px"
```

### Examples
```
angif "https://www.youtube.com/watch?v=dQw4w9WgXcQ" 0:43 8
```
This will create a 8 seconds gif from 0:43 seconds in the video, where the script is.
```
angif "https://www.youtube.com/watch?v=dQw4w9WgXcQ" 0:43 8 --dir ~/Downloads
```
This will do the same, except that the gif is created in ~/Downloads.

### Warnings
Depending on your OS, you may need not to use marks for the YouTube url. They are required on macOS but some friends had to remove them on Linux systems.

## Dependencies
- [zsh](http://zsh.sourceforge.net): this script is to be executed with zsh ;
- [youtube-dl](http://ytdl-org.github.io/youtube-dl/download.html): required to download the video ;
- [ffmpeg](https://ffmpeg.org/download.html): required to download the video, processing it and converting it into a gif.

## Maydo
- Find a way to copy the gif to the clipboard.

# 2pdf2images

p l a c e h o l d e r

# Contributing
if you want, please contribute or help by contacting me or making a pull request.

# Authors
- Antoine Hugounet: myself, creator of this repo.

# License

This project is licensed under the GNU General Public License v3.0 - see the [LICENSE.md](LICENSE.md) file for details.
