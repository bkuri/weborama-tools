#!node_modules/coffee-script/bin/coffee
'use strict'


axis = require('axis')
compression = require('compression')
express = require('express')
minify = require('express-minify')
routes = require('./routes')
stylus = require('stylus')
{version} = require('./package.json')

app = express()


compile = (str, path) ->
  stylus(str)
    .set 'filename', path
    .set 'compress', yes
    .use axis()

express.static.mime.define
  'text/coffeescript': ['coffee']
  'text/stylus': ['styl']

app.set 'views', "#{__dirname}/private/views"
app.set 'view engine', 'jade'

app.use stylus.middleware Object.assign {compile},
  dest: "#{__dirname}/public/css"
  src: "#{__dirname}/private/css"

app.use compression()
app.use minify()
app.use express.static("#{__dirname}/public")

routes.init(app, version)
app.listen (process.env.PORT or 8888)
