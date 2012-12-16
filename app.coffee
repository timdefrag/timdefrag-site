express = require('express')

app = express()

# Define routes
app.get('/hello', (req, res) ->
  body = 'hello world'
  res.setHeader('Content-Type', 'text/plain')
  res.setHeader('Content-Length', body.length)
  res.end(body)
)

# Export server
module.exports = app