'use strict'


JSZip = require('node-zip')


exports.init = (app, config, redis, version) ->
  app.get '/api/bundle', (req, res) ->
    data = {}
    zip = new JSZip()
    {folder} = req.query

    zip.folder(folder).load(data)
    res.set 'Content-Type', 'application/zip'
    res.send zip.generate(type: 'nodebuffer')
    return


  app.get '/wizard', (req, res) ->
    title = 'New template'
    res.render 'wizard', Object.assign(config, hits: 0, {title, version})
    return


  return
