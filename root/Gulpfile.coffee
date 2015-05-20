gulp        = require('gulp')
uglify      = require('gulp-uglify')
browserify  = require('browserify')
source      = require('vinyl-source-stream')
buffer      = require('vinyl-buffer')
sourcemaps  = require('gulp-sourcemaps')
compass     = require('gulp-compass')
minifyCSS   = require('gulp-minify-css')
clean       = require('gulp-clean')
runSequence = require('run-sequence')
browserSync = require('browser-sync')


dir =
  src       : "./src"
  dist      : "./dist"
  assets    : "./dist/assets"


gulp.task "clean", ->
  gulp.src "#{dir.dist}", {read : false}
  .pipe clean()


gulp.task "browserify", ->
  browserify "#{dir.src}/script.coffee"
  .bundle()
  .pipe source "script.js"
  .pipe buffer()
  .pipe sourcemaps.init({loadMaps : true})
  .pipe uglify()
  .pipe sourcemaps.write('./')
  .pipe gulp.dest "#{dir.assets}"


gulp.task "compass", ->
  gulp.src "#{dir.src}/style.scss"
  .pipe compass
    css       : "#{dir.assets}"
    sass      : "#{dir.src}"
    image     : "#{dir.assets}"
    sourcemap : true
  .pipe minifyCSS()
  .pipe gulp.dest "#{dir.assets}"


gulp.task "copy", ->
  gulp.src "#{dir.src}/index.html"
  .pipe gulp.dest "#{dir.dist}"


gulp.task 'browser-sync', ->
  browserSync
    server :  { baseDir : [ dir.dist, dir.src ], index: "index.html" }
    files :   [ "#{dir.build}/**/*", "!#{dir.build}/**/*.map"]

# Public Tasks
# ------------------------------
gulp.task "test", ->


gulp.task "build", (callback) ->
  runSequence 'clean','browserify','compass','copy', callback


gulp.task "server", ->
  runSequence 'build', 'browser-sync', ->
    gulp.watch  "#{dir.src}/style.scss",    ['compass', browserSync.reload]
    gulp.watch  "#{dir.src}/index.html",    ['copy', browserSync.reload]
    gulp.watch  "#{dir.src}/script.coffee",  ['browserify', browserSync.reload]


gulp.task 'default', ->
  console.log '\n'
  console.log ' Gulp Tasks'
  console.log ' ----------'
  console.log ''
  console.log '   $ gulp build'
  console.log '   $ gulp server'
  console.log '   $ gulp test'
  console.log '\n'



