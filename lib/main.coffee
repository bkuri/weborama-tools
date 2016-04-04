'use strict'


{compile} = require('coffee-script')
{memoize} = require('lodash')
{readFileSync} = require('fs')


FORMAT = ['JPG', 'image/jpeg']


exports.init = (app, config, ref, version) ->
  app.get '/js/:script.js', memoize (req, res) ->
    {script} = req.params

    read = (what) ->
      file = readFileSync("#{ __dirname }/../#{ what }", 'ascii')
      return compile(file) if what.match /\.coffee$/i
      return file

    res.header 'Content-Type', 'application/x-javascript'

    res.send read switch script
      when 'steps' then 'node_modules/jquery-steps/build/jquery.steps.min.js'
      else "private/js/#{ script }.coffee"

    return


  return
