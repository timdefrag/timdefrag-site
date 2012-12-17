# imports

express  = require('express')
_        = require('underscore')


# create server instance
app = express()

app.set('views', __dirname + '/view'

# for other requests, use the router
app.use(app.router)

# forward public file requests
app.use(express.static(__dirname + '/../public'))

# Init modules
_.each [
  'blog'
], (module) ->
  require("./#{module}") .init(app)




# Export server
module.exports = app