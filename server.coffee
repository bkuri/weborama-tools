#!node_modules/coffee-script/bin/coffee
'use strict'


axis = require('axis')
compression = require('compression')
express = require('express')
minify = require('express-minify')
routes = require('./lib/routes')
stylus = require('stylus')
{version} = require('./package.json')

app = express()


compile = (str, path) ->
  return stylus(str)
    .set 'filename', path
    .set 'compress', yes
    .use axis()

###
express.static.mime.define
  'text/coffeescript': ['coffee']
  'text/stylus': ['styl']
###

app.use (req, res, next) ->
  if (req.url is '/') or req.url.match(/(css|ico|js|json|png|svg|xml)$/)
    res.setHeader('Cache-Control', 'public, max-age=86400')

  next()
  return

app.use stylus.middleware Object.assign {compile},
  dest: "#{__dirname}/public/css"
  src: "#{__dirname}/private/css"

app.use compression()
app.use minify()
app.use express.static("#{__dirname}/public")

app.set 'views', "#{__dirname}/private/views"
app.set 'view engine', 'jade'

routes.init(app, version)
app.listen (process.env.PORT or 8888)
