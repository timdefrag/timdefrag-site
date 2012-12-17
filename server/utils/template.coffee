# imports
fs    = require 'fs'
jade  = require 'jade'
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
#     styles    :  builder.styles()
#     scripts   :  builder.scripts()
#     templates :  builder.templates()
#
#   res.render('view/blog.jade', html)
#   
module.exports.PageBuilder = class PageBuilder
  
  # requests
  reqs         = []
  
  # Accumulators
  stylesheets  = []
  scripts      = []
  templates    = ['base.jade']
  
  
  # Declare a resource dependency
  # 
  # @overload require(res)
  #   @param [String] res The path of a resource
  #   @return [Builder] this
  # 
  # @overload require(res)
  #   @param [Array<String>] res A list of resource paths
  #   @return [Builder] this
  #
  require: (res) =>
    
    # Array? Call require on each of them
    if (res instanceof Array)
      for r in res
        @require(r)
    
    # String? Handle if not encountered
    else if (typeof res == 'string')
      
      # Return if cached, otherwise cache
      if res in reqs then return
      reqs.push(res)
      
      ext = _.last( res.split('.') )  ?  ''
      
      # CSS?
      if ext == 'css'
        stylesheets.push "css/#{res}"
        
      # Script?
      else if ext == 'js'
        scripts.push "js/#{res}"
        
      # Template?
      else if ext == 'jade'
        templates.push { file: "templates/#{res}" }
    
    # return this
    this
      
  
  generate: (onComplete) =>
    tmplCount = 0
    tmplFns = {}
    
    for tmpl in templates
      fs.readFile tmpl.file, 'utf-8', (txt) ->
        tmpl.create = jade.compile(txt, {})
        tmplCount++
        
        if tmplCount >= templates.length
        
    
    styles:
      _.each stylesheets, (ss) ->
        "<link type=\"text/css\" rel=\"stylesheet\" href=\"#{ ss }\"></link>"
      .join('')
      
    scripts:
      _.each scripts, (js) ->
        "<script type=\"text/javascript\" src=\"#{ js }\"></script>"
      .join('')
      
    templates:
      _.each templates, (tmpl) ->
         "<script type=\"text/x-handlebars-template\">#{ tmpl }</script>"
      .join('')
      
      
      