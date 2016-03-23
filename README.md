Weborama tools
==============

A collection of tools for weborama creatives
--------------------------------------------

Install
-------

-	Pull a fresh version of this script: `git pull https://github.com/bkuri/weborama-tools.git`
-	Make sure you have coffeescript installed globally: `npm install -g coffeescript`
-	Install [GraphicsMagick](http://www.graphicsmagick.org/README.html)
-	Install required npm libs (run `npm install` inside the download folder)

Usage
-----

```sh
placeholder placeholder [options] <width> <height> <file>

  Options:

    -h, --help                output usage information
    -V, --version             output the version number
    -b, --background [color]  Background color
    -q, --quality [percent]   Quality %
```

Notes
-----

-	You may have to prefix the command with `coffee` under Windows/OSX (`coffee placeholder...`\)
-	`--gravity` accepts one of the following values:
	-	`NorthWest, North, NorthEast, West, Center, East, SouthWest, South, SouthEast`
-	Here's the official color reference: http://www.graphicsmagick.org/color.html
