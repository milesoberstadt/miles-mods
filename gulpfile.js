'use strict'

const browserify = require('browserify')
const cache = require('gulp-cached')
const coffee = require('gulp-coffee')
const gulp = require('gulp')
const sourcemaps = require('gulp-sourcemaps')
const uglify = require('gulp-uglify')

gulp.task('clean', (done) => {
  const del = require('del')
  delete cache.caches['build:vue']
  delete cache.caches['build:pug']
  del.sync([ 'dist/*' ])
  done()
})

gulp.task('build:assets:js', () => {
  return gulp.src('assets/js/**/*')
    .pipe(gulp.dest('dist/assets/js'))
})

gulp.task('build:assets:img', () => {
  return gulp.src('assets/img/**/*')
    .pipe(gulp.dest('dist/assets/img'))
})

gulp.task('build:sass', function () {
  const sass = require('gulp-sass')
  return gulp.src('assets/css/*.scss')
    .pipe(sass().on('error', sass.logError))
    .pipe(gulp.dest('dist/assets/css'))
})

gulp.task('build:pug', () => {
  const pug = require('gulp-pug');
  return gulp.src('src/client/index.pug')
    .pipe(cache('build:pug'))
    .pipe(pug({ data: {debug: true} }))
    .pipe(gulp.dest('dist/'))
})

gulp.task('build:server', () => {
  return gulp.src('src/server/**/*.coffee')
    .pipe(cache('build:server'))
    .pipe(coffee({ bare: true }))
    .pipe(gulp.dest('dist/'))
})

gulp.task('build:utils', () => {
  return gulp.src('src/utils/**/*.coffee')
    .pipe(cache('build:utils'))
    .pipe(coffee({ bare: true }))
    .pipe(gulp.dest('dist/utils/'))
})

gulp.task('build:vue', () => {
  // set up the browserify instance on a task basis
  const buffer = require('vinyl-buffer')
  const coffeeify = require('coffeeify')
  const gutil = require('gulp-util')
  const source = require('vinyl-source-stream')
  const vueify = require('vueify')
  const b = browserify({
    entries: './src/client/main.coffee',
    extensions: ['.coffee', '.vue'],
    debug: true,
    transform: [vueify, coffeeify]
  })

  return b.bundle()
    .pipe(source('web/client.min.js')) // output filename
    .pipe(cache('build:vue'))
    .pipe(buffer())
    .pipe(sourcemaps.init({ loadMaps: true }))
      .pipe(uglify())
      .on('error', gutil.log)
    .pipe(sourcemaps.write('./'))
    .pipe(gulp.dest('./dist')) // output dir
})

gulp.task('test:unit', [], () => {
  require('coffee-script/register');
  const mocha = require('gulp-mocha')
  return gulp.src(['test/**/*.coffee', '!test/*.coffee'], { read: false })
    .pipe(mocha({
      require: [
        './test/setup'
      ],
      timeout: 10000
    }))
    .once('error', (err) => {
      if (err.stack) {
        console.log(err.stack);
      } else {
        console.log(err);
      }
      process.exit(1);
    })
    .once('end', () => {
      process.exit();
    })
})

gulp.task('watch:client', [ 'build:client' ], () => {
  gulp.watch('src/client/**/*', { interval: 500 }, [ 'build:client' ])
})

gulp.task('watch:server', [ 'build:server' ], () => {
  gulp.watch('src/server/**/*.coffee', { interval: 500 }, [ 'build:server' ])
})

gulp.task('watch:utils', [ 'build:utils' ], () => {
  gulp.watch('src/utils/**/*.coffee', { interval: 500 }, [ 'build:utils' ])
})

gulp.task('build:assets', [ 'build:assets:js', 'build:assets:img' ])
gulp.task('build:client', [ 'build:vue', 'build:pug', 'build:assets' ])
gulp.task('build', [ 'clean', 'build:client', 'build:sass', 'build:utils', 'build:server' ])
gulp.task('test', [ 'test:unit' ])
gulp.task('watch', [ 'watch:client', 'watch:utils', 'watch:server' ])
gulp.task('default', [ 'build', 'watch' ])
