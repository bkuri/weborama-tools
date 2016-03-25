'use strict'


express = require('express')
nib = require('nib')
routes = require('./routes')
stylus = require('stylus')
{version} = require('./package.json')

app = express()


compile = (str, path) ->
  stylus(str)
    .set 'filename', path
    .set 'compress', yes
    .use nib()

app.set 'views', "#{__dirname}/private/views"
app.set 'view engine', 'jade'

app.use stylus.middleware Object.assign {compile},
  dest: "#{__dirname}/public/css"
  src: "#{__dirname}/private/css"

app.use express.static("#{__dirname}/public")

routes.init(app, version)
app.listen (process.env.PORT or 8888)
