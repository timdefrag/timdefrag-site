# imports
fs      = require 'fs'

_       = require 'underscore'
Stylus  = require 'stylus'
Coffee  = require 'coffeescript'


class Util
  
  constructor: ->
    
  
  clientCompileJS: =>
    
  
  clientCompileStylus: =>
    
  
  # Build a list of files contained in a directory
  #
  # @param 
  #
  recurseDir: (dir, opts = null) =>
    opts = _.defaults (opts ?= {}), 
      filter  : (path) -> true
      recurse : true
      dirs    : false
    
    files = (path) ->
      if fs.lstatSync(path).isDirectory()
        _.reduce [
          -> if opts.dirs     then [path]       else []
          -> if opts.recurse  then files(path)  else []
        ], (ls, fn) -> ls.concat(fn()), []
      else
        [path]
    
    _.chain(files(dir))
    .flatten()
    .filter(opts.filter)
    .value()
        
        
        
        
        
        
        
# Export utility functions
module.exports = new Util()
  
  
    
    
    
    
