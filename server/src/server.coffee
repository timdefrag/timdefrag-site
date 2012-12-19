# libs
_        = require('underscore')
Express  = require('express')


module.exports =
# Server
#
#
class Server
  
  # Initialize
  #
  #
  constructor: ->
    
  
  # Run Server
  #
  #
  run: =>
    
    # Init Express App
    @app = Express()
    @app.configure =>
      _.each(
        [ Express.static('client/public')
          @app.router ],
        (u) => @app.use u  )
    
    
    # Load Modules
      _.each(
        [ 'util', 'core', 'home', 'blog' ],
        (module) =>
          this[module] =
            new (require "./#{module}")(this)  )
    
    
    # Prepare public assets
    @util.compilePublicJS()
    @util.compilePublicCSS()
    
    
    # Route Index to Home Index
    @app.get '/',  @home.index
    
    
    # Listen for Requests
    server.app.listen(process.env.PORT);
    
    
  # Shutdown Server
  #
  #
  stop: =>
    


