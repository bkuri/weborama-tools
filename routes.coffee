'use strict'


{compile} = require('coffee-script')
JSZip = require('node-zip')
{memoize} = require('lodash')
minify = require('express-minify')
{readFileSync, writeFile} = require('fs')
ref = require('redis').createClient()

COLOR = '#DCDCDC'
FORMAT = ['JPG', 'image/jpeg']
HEIGHT = 180
QUALITY = 85
WIDTH = 960

locals =
  color: COLOR
  height: HEIGHT
  quality: QUALITY
  width: WIDTH

  url:
    bkuri: 'https://twitter.com/bkuri'
    colors: 'http://www.graphicsmagick.org/color.html'
    logos: '/img/logos.jpg'
    weborama: 'https://twitter.com/weborama'


exports.init = (app, version) ->
  app.get '/', (req, res) ->
    ref.get 'hits', (err, hits) ->
      title = 'Placeholder'
      res.render 'placeholder', Object.assign({hits, title, version}, locals)
      return
    return


  app.get '/bundle', (req, res) ->
    title = 'New template'
    res.render 'bundle', Object.assign({title, version}, locals)
    return


  app.get '/api/placeholder', (req, res) ->
    try
      {logo, width, height, color, quality, gravity} = req.query

      (require 'gm')("public/img/#{logo}.png")
        .background color
        .gravity gravity
        .extent width, height
        .quality quality

        .toBuffer FORMAT[0], (err, buffer) ->
          if err?
            res.status(500).send("Internal Server Error\n#{err}")
            return

          ref.incr 'hits'
          res.set 'Content-Type', FORMAT[1]
          res.send buffer

    catch err
      console.error err
      res.status(400).send("Bad Request\n#{JSON.stringify req.query}")

    return


  app.get '/api/zip', (req, res) ->
    zip = new JSZip()
    {folder} = req.query

    data = {}
    zip.folder(folder).load(data)
    res.set 'Content-Type', 'application/zip'
    res.send zip.generate(type: 'nodebuffer')
    return


  app.get '/js/app.js', memoize (req, res) ->
    file = readFileSync("#{__dirname}/private/js/app.coffee", 'ascii')

    res.header 'Content-Type', 'application/x-javascript'
    res.send compile(file)
    return
