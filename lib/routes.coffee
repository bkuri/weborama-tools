'use strict'


{compile} = require('coffee-script')
JSZip = require('node-zip')
gm = require('gm')
{invert} = require('./color')
{memoize} = require('lodash')
minify = require('express-minify')
{readFileSync, writeFile} = require('fs')
ref = require('redis').createClient()

FORMAT = ['JPG', 'image/jpeg']

config =
  bcolor: '#dcdcdc'
  height: 180
  quality: 85
  width: 960

  url:
    bkuri: 'https://twitter.com/bkuri'
    colors: 'http://www.graphicsmagick.org/color.html'
    logos: '/img/logos.jpg'
    weborama: 'https://twitter.com/weborama'


exports.init = (app, version) ->
  app.get '/placeholder', (req, res) ->
    ref.get 'hits', (err, hits) ->
      title = 'Placeholder'
      res.render 'placeholder', Object.assign(config, {hits, title, version})
      return
    return


  app.get '/', (req, res) ->
    title = 'New template'
    res.render 'bundle', Object.assign(config, hits: 0, {title, version})
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
      res.status(400).send("Bad Request\n#{err}\n#{JSON.stringify req.query}")

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
    file = readFileSync("#{__dirname}/../private/js/app.coffee", 'ascii')

    res.header 'Content-Type', 'application/x-javascript'
    res.send compile(file)
    return
