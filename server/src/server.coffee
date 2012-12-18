# imports

express  = require('express')
_        = require('underscore')


# Server Module
class Server
  
  # Initialize
  constructor: ->
    
    # Init Express App
    @app = express()
    @app.configure =>
      @app.use express.static(__dirname + '/../../client/public')
      @app.use @app.router
    
    
    # Load Modules
    @modules = {}
    _.each [
      'core', 'home', 'blog'
    ], (m) =>
      module = @modules[m] = require("./modules/#{m}")
      module.init?(this)
      
    
    # Route Index to Home Page
    @app.get '/',  @modules.home.index


# Run Server
server = module.exports = new Server();
server.app.listen(process.env.PORT);

