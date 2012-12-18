# imports
fs = require 'fs'




blogMain = (req, res) ->
  res.render('blog.jade', {
    
  })


# initialization
module.exports.init = (app) ->
  
  # route requests
  app.get('/blog', main)
  