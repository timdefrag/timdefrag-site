# node
fs      = require 'fs'

# libs
_       = require 'underscore'
Stylus  = require 'stylus'
Coffee  = require 'coffee-script'
Async   = require 'async'


module.exports =
# Global utilities
#
#
class Util
  
  constructor: (@server) ->
    
  
  
  # Asynchronously compile client-side app assets,
  # report on success or errors.
  #
  # @param [Object] opts
  # @option opts [String] coffeePath
  #
  compileClient: (opts) =>
    
    # Defaults
    opts = _.defaults (opts ? {}),
      coffeePath  : 'client/coffee'
      stylPath    : 'client/stylus'
      jadePath    : 'client/jade'
      targetPath  : 'public/app.html'
      callback    : ((err) -> null)
    
    # Serially execute compile phases
    console.log('Compiling Client App ...')
    Async.forEach \
      [ (done) ->
          console.log('Styl -> Css ...')
          file = opts.stylPath + '/index.styl'
          Stylus.render \
            fs.readFileSync(file, 'utf-8'),
            { filename: file },
            (err, css) ->
              done(err)
              
        (done) ->
          console.log('Coffee -> JS ...')
          done()
          
        (done) ->
          console.log('Jade -> HTML ...')
          done()
          
        (done) ->
          console.log("Compile -> #{opts.targetPath} ...")
          done() ],
          
      ((fn, cb) -> fn cb),
      (err) ->
        console.log \
          if err? 
            'ERROR:\n' + err + '\n'
          else
            "SUCCESS\n"
        opts.callback(err)
    
  
  # Build a list of files contained in a directory
  #
  # @param 
  #
  findFiles: (dir, opts) =>
    opts = _.defaults (opts ? {}), 
      filter  : (path) -> true
      recurse : true
      dirs    : false
    
    # Path tree builder
    files = (path) ->
      if fs.lstatSync(path).isDirectory()
        _.reduce \
          [ (ps) -> if opts.dirs
              ps.push path
            (ps) -> if opts.recurse
              ps.concat \
                _.chain fs.readdirSync(path)
                .map (path) -> files(path)
                .reduce ((a, fs) -> a.concat fs),  [] ],
        ((paths, fn) ->
          fn paths
          paths  ), 
        []
      else [path]
    
    # Flatten, filter, return
    _.chain files(dir)
    .flatten()
    .filter opts.filter
    .value()
  
    
    
    
    
