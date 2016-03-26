Weborama tools
==============

A collection of tools for weborama creatives
--------------------------------------------

Install
-------

-	Install [Redis](http://redis.io/download)
-	Install [GraphicsMagick](http://www.graphicsmagick.org/README.html)
-	Install [Node Package Manager](https://www.npmjs.com/package/npm)
-	Pull a fresh version of this script: `git clone https://github.com/bkuri/weborama-tools.git`
-	Run `npm install` inside the download folder

### Web version

![Screenshot](https://i.imgur.com/o9Vf2yt.png)

Simply run `npm start` inside the download folder and open up a browser tab pointing to http://localhost:8888. Make sure that your redis server is running in the background.

### CLI version

A command line version is available inside the `cli` folder. Usage is as follows:

```sh
placeholder placeholder [options] <width> <height> <file>

  Options:

    -h, --help                output usage information
    -V, --version             output the version number
    -b, --background [color]  Background color
    -q, --quality [percent]   Quality %
```

#### Notes

-	You may have to prefix the command with `coffee` under Windows/OSX (`coffee placeholder...`\)
-	`--gravity` accepts one of the following values: `NorthWest, North, NorthEast, West, Center, East, SouthWest, South, SouthEast`
-	Here's the official color reference: http://www.graphicsmagick.org/color.html
