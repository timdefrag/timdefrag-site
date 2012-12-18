# Configure RequireJS
require.config {
  baseUrl: '../js'
}


# Client
define 'client', [
  'lib/require'
  'lib/jquery'
  'lib/underscore'
  'lib/ember'
], (require, $, _, Ember) ->
  
  class Client
    
    constructor: =>
      
      # Init EmberJS
      
      
      # Load Modules
      @modules = []
      _.each [
        'core', 'home', 'blog'
      ], (id) =>
        require "modules/#{id}", (module) ->
          module.init?(this)
          @modules.push(module)
        
        
    
      
      
    
  
  # Export client object
  new Client()
  
  