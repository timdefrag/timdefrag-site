# imports
_     = require 'underscore'
_str  = require 'underscore.string'




class Builder
  
  # requests
  reqs         = []
  
  # Accumulators
  stylesheets  = []
  scripts      = []
  templates    = []
  
  # Type-specific resource operations
  handlers = [
    { # Stylesheets
      ext     : 'css'
      require : ( name ) ->
        
    },
    { # Scripts
      ext     : 'js'
      require : ( name ) ->
        
    },
    { # Templates
      ext     : 'html'
      require : ( name ) ->
        
    },
    { # Fallthrough
      require: ( name ) ->
        
    }
  ]
  
  
  #   private  Handler  getHandler  ( string  name )
  #   ----------------------------------------------  
  #   Return handler based on resource extension.
  
  getHandler = ( name ) ->
    ext = _.last( name.split('.') )
    _.chain( handlers )
      .filter( (h) -> h.ext == ext )
      .first()
      .value()
  
  
  #   public  Builder  require  ( string  res )
  #   -----------------------------------------
  #   Declare a required resource for the page.
  #   Return this.
  
  require: (res = '') ->
    
    # Ignore previously requested resources
    if res in reqs then return
    
    # Add to requested resources
    reqs.push(res)
    
    # Extract resource extension
    ext = _.last( res.split('.') )  ?  ''
    
    
      
  
  

module.exports =
  Builder: Builder
  
  init: (app) ->
    