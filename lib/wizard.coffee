'use strict'


JSZip = require('node-zip')


exports.init = (app, config, redis, version) ->
  app.get '/api/bundle', (req, res) ->
    data = {}
    zip = new JSZip()
    {folder} = req.query

    zip.folder(folder).load(data)
    redis.incr 'templates'
    res.set 'Content-Type', 'application/zip'
    res.send zip.generate(type: 'nodebuffer')
    return


  app.get '/wizard', (req, res) ->
    redis.get 'templates', (err, hits) ->
      title = 'New template'

      res.render 'wizard', Object.assign(config, {hits, title, version})
      return


  return
