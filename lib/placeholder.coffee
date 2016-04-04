'use strict'


gm = require('gm')
{invert} = require('./color')


FORMAT = ['JPG', 'image/jpeg']


exports.init = (app, config, redis, version) ->
  app.get '/api/placeholder', (req, res) ->
    try
      {bcolor, gravity, height, logo, quality, width} = req.query

      gm("public/img/#{ logo }.png")
        .background bcolor
        .gravity gravity
        .extent (width - 4), (height - 4)
        .borderColor invert(bcolor)
        .border 2, 2
        .quality quality

        .toBuffer FORMAT[0], (err, buffer) ->
          if err?
            res
              .status 500
              .send "Internal Server Error\n#{ err }"
            return

          redis.incr 'hits'
          res.set 'Content-Type', FORMAT[1]
          res.send buffer
          return

    catch err
      res
        .status 400
        .send "Bad Request\n#{ err }\n#{ JSON.stringify(req.query) }"

    return


  app.get '/placeholder', (req, res) ->
    redis.get 'hits', (err, hits) ->
      res.render 'placeholder', Object.assign(config, title: 'Placeholder', {hits, title, version})
      return

    return


  return
