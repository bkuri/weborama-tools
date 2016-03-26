'use strict'


{compile} = require('coffee-script')
{readFileSync} = require('fs')

Firebase = require('firebase')
ref = new Firebase('https://shining-inferno-8940.firebaseio.com')

FORMAT = ['JPG', 'image/jpeg']


exports.init = (app, version) ->
  app.get '/', (req, res) ->
    res.render 'placeholder',
      title: 'New placeholder image'
      version: version

      url:
        bkuri: 'https://twitter.com/bkuri'
        colors: 'http://www.graphicsmagick.org/color.html'
        weborama: 'https://twitter.com/weborama'


  app.get '/api/placeholder', (req, res) ->
    try
      # TODO offer more logo types
      type = 'logo1'
      {width, height, color, quality, gravity} = req.query

      (require 'gm')("public/img/#{type}.png")
        .background color
        .gravity gravity
        .extent width, height
        .quality quality

        .toBuffer FORMAT[0], (err, buffer) ->
          if err?
            res.status(500).send("Internal Server Error\n#{err}")
            return

          ref.push {version, type, width, height, color, quality, gravity}, ->
            console.log 'new hit'

          res.set 'Content-Type', FORMAT[1]
          res.send buffer

    catch err
      console.error err
      res.status(400).send("Bad Request\n#{JSON.stringify req.query}")


  app.get '/js/app.js', (req, res) ->
    file = readFileSync("#{__dirname}/private/js/app.coffee", 'ascii')

    res.header 'Content-Type', 'application/x-javascript'
    res.send compile(file)
