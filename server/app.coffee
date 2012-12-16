# import express library
express = require('express')

# create server instance
app = express()

# forward public file requests
app.use(express.static(__dirname + '/../public'))

# for other requests, use the router
app.use(app.router)

# Define routes
app.get('/hello', (req, res) ->
  body = 'hello world'
  res.setHeader('Content-Type', 'text/plain')
  res.setHeader('Content-Length', body.length)
  res.end(body)
)

# Export server
module.exports = app