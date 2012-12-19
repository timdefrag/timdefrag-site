# node
fs      = require 'fs'

# libs
_       = require 'underscore'
Stylus  = require 'stylus'
Coffee  = require 'coffee-script'


module.exports =
# Global utilities
#
#
class Util
  
  constructor: (@server) ->
    
  
  
  # Generate new client.js file from CoffeeScript source.
  compilePublicJS: =>
    
  
  
  # Generate new client.css file from Stylus source.
  compilePublicCSS: =>
    Stylus.render(
      fs.readFileSync('client/stylus/client.styl', 'utf-8'),
      (err, css) ->
        fs.writeFileSync('client/public/css/client.css', css)  )
  
  
  
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
        [ (ps) ->
            if opts.dirs
              ps.push path
          (ps) ->
            if opts.recurse
              ps.concat( 
                _.chain fs.readdirSync(path)
                .map (path) -> files(path)
                .reduce ((a, fs) -> a.concat fs),  []  )],
        ((paths, fn) ->
          fn paths
          paths  ), 
        [] )
      else [path]
    
    # Flatten, filter, return
    _.chain(files(dir))
    .flatten()
    .filter(opts.filter)
    .value()
  
    
    
    
    
