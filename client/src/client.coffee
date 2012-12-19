
  
  #
  #
  class Client
    
    #
    #
    constructor: ->
      
      # Create EmberJS App
      @app = Ember.Application.create()
      
      
      # Load Modules
      @modules = []
      _.each [
        #(module) => 
      ], (fn) ->
        _.each [
          'core', 'home', 'blog'
        ], (id) =>
          require(id, fn)
          
      
      # Initialize EmberJS App
      @app.initialize()
        
    
  # Export client object
  new Client()
  
  