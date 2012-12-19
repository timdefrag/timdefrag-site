# imports
fs      = require 'fs'

_       = require 'underscore'
Stylus  = require 'stylus'
Coffee  = require 'coffeescript'


module.exports = class Util
  
  constructor: ->
    
  
  
  # Generate new client.js file from CoffeeScript source.
  compilePublicJS: =>
    
  
  
  # Generate new client.css file from Stylus source.
  compilePublicCSS: =>
    Stylus.render '', {
      filename: 'client/public/css/client.css'
      paths:
        @findFiles 'client/stylus', {
          filter: (path) ->
            _.last(path.split '.') == 'styl'  }}
  
  
  
  # Build a list of files contained in a directory
  #
  # @param 
  #
  findFiles: (dir, opts = null) =>
    
    # Default configuration
    opts = _.defaults (opts ?= {}), 
      filter  : (path) -> true
      recurse : true
      dirs    : false
    
    # Path tree builder
    files = (path) ->
      if fs.lstatSync(path).isDirectory()  then  _.reduce(
        [ ((ps) -> if opts.dirs     then  ps.push path)
          ((ps) -> if opts.recurse  then  ps.concat( 
            _.chain(fs.readdirSync path)
            .map (path) -> files(path)
            .reduce (a, fs) -> a.concat p,  []  ))],
        (paths, fn) -> fn(paths), [] )
      else [path]
    
    # Flatten, filter, return
    _.chain(files(dir))
    .flatten()
    .filter(opts.filter)
    .value()
        
        
# Export utility functions
module.exports = new Util()
  
  
    
    
    
    
