#!node_modules/coffee-script/bin/coffee
'use strict'


axis = require('axis')
compression = require('compression')
express = require('express')
main = require('./lib/main')
minify = require('express-minify')
placeholder = require('./lib/placeholder')
redis = require('redis').createClient()
stylus = require('stylus')
{version} = require('./package.json')
wizard = require('./lib/wizard')


CONFIG =
  bcolor: '#dcdcdc'
  height: 180
  quality: 85
  width: 960

  url:
    bkuri: '//twitter.com/bkuri'
    colors: '//www.graphicsmagick.org/color.html'
    fonts: '//fonts.googleapis.com/css?family=Fjalla+One|Roboto'
    logos: '/img/logos.jpg'
    weborama: '//twitter.com/weborama'


app = express()


compile = (str, path) ->
  return stylus(str)
    .set 'filename', path
    .set 'compress', yes
    .use axis()


app.set 'views', "#{__dirname}/private/views"
app.set 'view engine', 'jade'

app.use (req, res, next) ->
  if (req.url is '/') or req.url.match(/(css|ico|js|json|png|svg|xml)$/)
    res.setHeader 'Cache-Control', 'public, max-age=86400'

  next()
  return

app.use stylus.middleware Object.assign {compile},
  dest: "#{__dirname}/public/css"
  src: "#{__dirname}/private/css"

app.use compression()
app.use minify()
app.use express.static("#{__dirname}/public")

main.init app, CONFIG, redis, version
placeholder.init app, CONFIG, redis, version
wizard.init app, CONFIG, redis, version

app.listen (process.env.PORT or 8888)
