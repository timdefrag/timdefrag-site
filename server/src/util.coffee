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
      [ (done) =>
          console.log('  Styl -> Css ...')
          file = opts.stylPath + '/index.styl'
          Stylus.render \
            fs.readFileSync(file, 'utf-8'),
            { filename: file },
            (err, css) ->
              done(err)
              
        (done) =>
          console.log('  Coffee -> JS ...')
          _.each \
            findFiles(opts.coffeePath, {
              filter: (path) -> path[7..] == 'coffee' }),
            (path) =>
              
              
            
          done()
          
        (done) =>
          console.log('  Jade -> HTML ...')
          done()
          
        (done) =>
          console.log("  Compile -> #{opts.targetPath} ...")
          done() ],
          
      ((fn, cb) -> fn cb),
      (err) ->
        console.log \
          if err? 
            'ERROR:\n' + err + '\n'
          else
            "SUCCESS\n"
        opts.callback(err)
    
  
  # Build a list of the paths in a directory.
  #
  # @param    [String] folder?  Search directory (default cwd.)
  # @param  [Function] filter?  File path predicate.
  # @param    [Object] opts?    Options.
  #
  # @options opts    [String] search   Search path
  # @options opts  [Function] filter   File path predicate
  # @options opts   [Boolean] recurse  Check subfolders?
  # @options opts   [Boolean] dirs     Report folder names?
  #
  findFiles: (args...) =>
    
    # Defaults
    opts = 
      search  : ''
      filter  : (path) -> true
      recurse : true
      dirs    : false
    
    # Arguments
    for a in args
      if    _.isString a  then  opts.search = a
      if  _.isFunction a  then  opts.filter = a
      if    _.isObject a  then  opts = _.defaults a, opts
    
    # Walk file tree
    walk = (path) ->
      if fs.lstatSync(path).isDirectory()
        ps = []
        if opts.dirs
          ps.push path
        if opts.recurse
          ps = ps.concat \
            _.chain  fs.readdirSync(path)
            .map     (path) -> walk(path)
            .reduce  (a, fs) -> (a.concat fs),  []
        ps
      else
        [path]
    
    # Flatten, filter, return
    _.chain files(dir)
    .flatten()
    .filter opts.filter
    .value()
  
    
    
    
    
