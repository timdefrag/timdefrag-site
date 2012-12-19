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
  findFiles: (dir, opts = null) =>
    opts = _.defaults (opts ?= {}), 
      filter  : (path) -> true
      recurse : true
      dirs    : false
    
    files = (path) ->
      if fs.lstatSync(path).isDirectory()  then  _.reduce(
        [ (ps) -> if opts.dirs     then  ps.push path,
          (ps) -> if opts.recurse  then  ps.concat( 
            _.chain(fs.readdirSync path)
            .map (path) -> files(path)
            .reduce (a, fs) -> a.concat p,  []  )],
        (paths, fn) -> fn(paths), [] )
      else [path]
    
    _.chain(files(dir))
    .flatten()
    .filter(opts.filter)
    .value()
        
        
# Export utility functions
module.exports = new Util()
  
  
    
    
    
    
