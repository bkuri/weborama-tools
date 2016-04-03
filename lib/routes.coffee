'use strict'


{compile} = require('coffee-script')
JSZip = require('node-zip')
gm = require('gm')
{invert} = require('./color')
{memoize} = require('lodash')
minify = require('express-minify')
{readFileSync} = require('fs')
ref = require('redis').createClient()


CONFIG =
  bcolor: '#dcdcdc'
  height: 180
  quality: 85
  width: 960

  url:
    bkuri: '//twitter.com/bkuri'
    colors: '//www.graphicsmagick.org/color.html'
    fonts: '//fonts.googleapis.com/css?family=Fjalla+One|Roboto'
    logos: '/img/logos.jpg'
    weborama: '//twitter.com/weborama'

FORMAT = ['JPG', 'image/jpeg']


exports.init = (app, version) ->
  app.get '/placeholder', (req, res) ->
    ref.get 'hits', (err, hits) ->
      title = 'Placeholder'
      res.render 'placeholder', Object.assign(CONFIG, {hits, title, version})
      return
    return


  app.get '/', (req, res) ->
    title = 'New template'
    res.render 'wizard', Object.assign(CONFIG, hits: 0, {title, version})
    return


  app.get '/api/placeholder', (req, res) ->
    try
      {logo, width, height, bcolor, quality, gravity} = req.query

      gm("public/img/#{logo}.png")
        .background bcolor
        .gravity gravity
        .extent (width - 4), (height - 4)
        .borderColor invert(bcolor)
        .border 2, 2
        .quality quality

        .toBuffer FORMAT[0], (err, buffer) ->
          if err?
            res.status(500).send("Internal Server Error\n#{err}")
            return

          ref.incr 'hits'
          res.set 'Content-Type', FORMAT[1]
          res.send buffer
          return

    catch err
      res.status(400).send "Bad Request\n#{err}\n#{JSON.stringify req.query}"

    return


  app.get '/api/zip', (req, res) ->
    data = {}
    zip = new JSZip()
    {folder} = req.query

    zip.folder(folder).load(data)
    res.set 'Content-Type', 'application/zip'
    res.send zip.generate(type: 'nodebuffer')
    return


  app.get '/js/:script.js', memoize (req, res) ->
    {script} = req.params

    read = (what) ->
      file = readFileSync("#{__dirname}/../#{what}", 'ascii')
      return compile(file) if what.match /\.coffee$/i
      return file

    res.header 'Content-Type', 'application/x-javascript'

    res.send read switch script
      when 'steps' then 'node_modules/jquery-steps/build/jquery.steps.min.js'
      else "private/js/#{script}.coffee"

    return
