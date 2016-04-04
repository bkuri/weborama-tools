'use strict'


{compile} = require('coffee-script')
{memoize} = require('lodash')
{readFileSync} = require('fs')


FORMAT = ['JPG', 'image/jpeg']


exports.init = (app, config, ref, version) ->
  app.get '/', (req, res) ->
    res.redirect '/wizard'
    return


  app.get '/js/:script.js', memoize (req, res) ->
    what = switch req.params.script
      when 'steps' then 'node_modules/jquery-steps/build/jquery.steps.min.js'
      else "private/js/#{ req.params.script }.coffee"

    file = readFileSync("#{ __dirname }/../#{ what }", 'ascii')

    res.header 'Content-Type', 'application/x-javascript'
    res.send if what.match(/\.coffee$/i) then compile(file) else file
    return


  return
