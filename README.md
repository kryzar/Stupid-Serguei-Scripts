# Angif

Given a YouTube video url, a starting time and a duration, [Angif](Angif.sh) creates a gif of the video from the starting time and of the duration you gave it. See options below.

[Angif](Angif.sh) comes as a single file zsh script.

## Purpose
I made this script when I realised it could be a formidable tool to write [Anki](https://apps.ankiweb.net) flashcards. Apart from my mathematical studies, a great hobby of mine is cooking and I spend quite a lot of time watching videos of chefs cooking ; I always have the pleasure of stumbling open new techniques and movements (e.g. a gesture technique to [make an omurice](https://www.youtube.com/watch?v=rFAddL8g8mw)). Of course, I want to memorize them, but putting movements or gestures into words can be quite tricky and unproductive. Conversely, being able to observe the movements — with all its finesse and details — is the best way to memorize it when it is impossible to practice on a regular basis.

Angif helps me creating flashcards on the spot when watching a video. If there is something in the video I want to memorize, I just just give the relevant extract to Angif and then copy the gif to directly put it as an answer in my  Anki flashcard. Here is an example of such a card.

![Anki flashcard using Angif](bin/Anki-example.gif)

There are numerous other things one can memorize with Anki and Angif: tie knots, gardening, dance moves, etc.

## Usage

### Basic usage
```
angif [-h/--help]
angif <url> <starting time> <duration> [options]
```

### Options
```
-h/--help		display the help message
-d/--directory <dir>	create the gif in the specified <dir> directory
-f/--fps <val>		choose the number of fps in the gif, default is minimum of video frame rate and 10 fps
-w/--width <val>	choose the width (in px) of the gif, default is minimum of video width and 800 px
```

### Examples
```
angif "https://www.youtube.com/watch?v=dQw4w9WgXcQ" 0:43 8
```
This creates an 8 seconds gif from 0:43 seconds in the video, where the script is.
```
angif "https://www.youtube.com/watch?v=dQw4w9WgXcQ" 0:43 8 --dir ~/Downloads
```
This does the same, except that the gif is created in ~/Downloads.

### Warning
Depending on your OS, you may need to remove the quotes for the YouTube url. They are required on macOS but some friends had to remove them on Linux systems.

## Dependencies
- [zsh](http://zsh.sourceforge.net): this script is to be executed with zsh ;
- [youtube-dl](http://ytdl-org.github.io/youtube-dl/download.html): required to download the video ;
- [ffmpeg](https://ffmpeg.org/download.html): required to download the video, processing it and convert it into a gif.

## Maydo
- Find a way to copy the gif to the clipboard ;
- add options to choose maximum possible width or frame rate ;
- rewrite comments ;
- make it work with Bash.

# 2pdf2images

p l a c e h o l d e r

# Contributing
If you encounter any bug, please let me know. If you wish to contribute or help anyhow, please contact me or send a pull request.

# Authors
- Antoine Hugounet: myself, creator of this repo.

# License

This project is licensed under the GNU General Public License v3.0 - see the [LICENSE.md](LICENSE.md) file for details.
