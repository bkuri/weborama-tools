#!/bin/coffee
'use strict'


express = require('express')
gm = require('gm')

COLOR = '#DCDCDC'
FORMAT = ['JPG', 'image/jpeg']
GRAVITY = 'Center'
LOGO = 'weborama_logo.png'
QUALITY = 92
app = express()

app.get '/api/placeholder', (req, res) ->
  try
    {width, height, color, quality, gravity} = req.query

    gm(LOGO)
      .background color or COLOR
      .gravity gravity or GRAVITY
      .extent width, height
      .quality quality or QUALITY

      .toBuffer FORMAT[0], (err, buffer) ->
        if err?
          res.status(500).send("Internal Server Error\n#{err}")
          return

        res.set 'Content-Type', FORMAT[1]
        res.send buffer

  catch err
    res.status(400).send("Bad Request\n#{JSON.stringify req.query}")

app.listen 8888
