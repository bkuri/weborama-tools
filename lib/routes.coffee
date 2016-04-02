'use strict'


{compile} = require('coffee-script')
gm = require('gm')
{invert} = require('./color')
{memoize} = require('lodash')
minify = require('express-minify')
{readFileSync} = require('fs')
ref = require('redis').createClient()


BCOLOR = '#DCDCDC'
FORMAT = ['JPG', 'image/jpeg']
HEIGHT = 180
QUALITY = 85
WIDTH = 960


exports.init = (app, version) ->
  app.get '/', (req, res) ->
    ref.get 'hits', (err, total) ->

      res.render 'placeholder',
        bcolor: BCOLOR
        height: HEIGHT
        hits: total
        quality: QUALITY
        title: 'Placeholder'
        version: version
        width: WIDTH

        url:
          bkuri: 'https://twitter.com/bkuri'
          colors: 'http://www.graphicsmagick.org/color.html'
          logos: '/img/logos.jpg'
          weborama: 'https://twitter.com/weborama'

      return
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
      console.error err
      res.status(400).send("Bad Request\n#{JSON.stringify req.query}")

    return


  app.get '/js/app.js', memoize (req, res) ->
    file = readFileSync("#{__dirname}/../private/js/app.coffee", 'ascii')

    res.header 'Content-Type', 'application/x-javascript'
    res.send compile(file)
    return
