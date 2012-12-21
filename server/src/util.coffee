# node
fs      = require 'fs'

# libs
_       = require 'underscore'
Stylus  = require 'stylus'
Coffee  = require 'coffee-script'
Async   = require 'async'
Uglify  = require 'uglify-js'


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
      jsLibPath   : 'client/jslib'
      stylPath    : 'client/stylus'
      jadePath    : 'client/jade'
      targetPath  : 'public/app.html'
      callback    : ((err) -> null)
    
    # Serially execute compile phases
    context = 
      compiledCSS  : ''
      jsLibs       : ''
      compiledJS   : ''
      compiledHTML : ''
      
    console.log('Compiling Client App ...')
    Async.forEach \
      [ # Compile Jade source to HTML
        (done) =>
          console.log('  Jade -> HTML ...')
          done()
        
        # Compile Stylus source to CSS
        (done) =>
          console.log('  Styl -> Css ...')
          file = opts.stylPath + '/index.styl'
          Stylus.render \
            fs.readFileSync(file, 'utf-8'),
            { filename: file, compress: true },
            (err, css) ->
              done(err)
        
        # Compile CoffeeScript source to JS
        (done) =>
          console.log('  Coffee -> JS ...')
          for path in @findFiles(
                        opts.coffeePath,
                        (p) -> _.last(p.split('.')) == 'coffee' )
            console.log "    #{path} ..."
            src = fs.readFileSync(path, 'utf-8')
            try
              context.compiledJS += Coffee.compile(src)
            catch err
              done(err)
              return
          done()
        
        # Compress JavaScript
        (done) =>
          console.log('  Compressing JS ...')
          try
            context.compiledJS =
              Uglify.minify(
                context.compiledJS,
                fromString: true )
              .code
          catch err
            done(err)
          done()
          
        # Mix in pre-minified JS libraries
        (done) =>
          console.log('  Mixin JS Libs ...')
          code = ''
          for path in @findFiles(
                        opts.jsLibPath,
                        (p) -> _.last(p.split('.')) == 'coffee' )
            console.log("    #{path} ...")
            code +=
              fs.readFileSync(path, 'utf-8')
            context.compiledJS =
              code + context.compiledJS
          done()
          
        # Pack code assets
        (done) =>
          console.log("  Packing into #{opts.targetPath} ...")
          output =
            [ '<html><head><style>'
              context.compiledCSS
              '</style><script type="text\javascript">'
              context.compiledJS
              '</script></head><body>'
              context.compiledHTML
              '</body></html>' ].join ''
          fs.writeFileSync opts.targetPath, output, 'utf-8'
          done() ],
          
      ((fn, cb) => fn cb),
      (err) =>
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
    walk = (path) =>
      if fs.lstatSync(path).isDirectory()
        ps = []
        if opts.dirs
          ps.push path
        if opts.recurse
          ps = ps.concat \
            _.chain( fs.readdirSync(path) )
            .map( (p) => walk "#{path}/#{p}" )
            .reduce( ((a, b) => a.concat b), [] )
            .value()
        ps
      else
        [path]
    
    # Flatten, filter, return
    _.chain( walk opts.search )
    .flatten()
    .filter( opts.filter )
    .value()
  
    
    
    
    
