# imports
_     = require 'underscore'
_str  = require 'underscore.string'



# Utility for accumulating page components and generating HTML.
#
# @example Build and generate.
#   builder = new Builder
#   builder.require [ 'css/blog.css', 'js/blog.js', 'blog.html' ]
#   builder.require [ 'css/portfolio.css', 'js/portfolio.js' ]
#   
#   html = 
#     styles    :  bldr.writeStyles()
#     scripts   :  bldr.writeScripts()
#     templates :  bldr.writeTemplates()
#
#   res.render('view/blog.jade', html)
#   
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
      require : (name) ->
        stylesheets.push name
    },
    { # Scripts
      ext     : 'js'
      require : (name) ->
        scripts.push name
    },
    { # Templates
      ext     : 'html'
      require : (name) ->
        templates.push name
    },
    { # Fallthrough
      require: (name) ->
        
    }
  ]
  
  
  # Return handler according to resource type
  #
  # @param [String] resName Path to extract extension from
  # @return [Object] Actions for this resource type
  #
  handler = (resName) ->
    ext = _.last( resName.split('.') )
    _.chain(handlers)
      .filter( (h) -> h.ext == ext )
      .first()
      .value()
  
  
  # Declare a resource dependency
  # 
  # @overload require(res)
  #   @param [String] res The path of a resource
  #   @return [Builder] this
  # 
  # @overload
  #   @param [Array<String>] res A list of resource paths
  #   @return [Builder] this
  #
  require: (res) ->
    
    # Ignore previously requested resources
    if res in reqs then return
    
    # Add to requested resources
    reqs.push(res)
    
    # Extract resource extension
    ext = _.last( res.split('.') )  ?  ''
    
    
      
  
  

module.exports =
  Builder: Builder
  
  init: (app) ->
    