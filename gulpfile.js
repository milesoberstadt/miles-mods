'use strict'

const browserify = require('browserify')
const cache = require('gulp-cached')
const coffee = require('gulp-coffee')
const gulp = require('gulp')
const sourcemaps = require('gulp-sourcemaps')
const uglify = require('gulp-uglify')

function clean(done) {
  const del = require('del')
  delete cache.caches['build:vue']
  delete cache.caches['build:pug']
  del.sync([ 'dist/*' ])
  done()
}
exports.clean = clean;

function build_assets_js() {
  return gulp.src('assets/js/**/*')
  .pipe(gulp.dest('dist/assets/js'))
}

function build_assets_img() {
  return gulp.src('assets/img/**/*')
    .pipe(gulp.dest('dist/assets/img'))
}

function build_assets_fonts() {
  return gulp.src('assets/fonts/**/*')
    .pipe(gulp.dest('dist/assets/fonts'))
}

function build_sass() {
  const sass = require('gulp-sass')
  return gulp.src('assets/css/*.scss')
    .pipe(sass().on('error', sass.logError))
    .pipe(gulp.dest('dist/assets/css'))
}

function build_pug() {
  const pug = require('gulp-pug');
  return gulp.src('src/client/index.pug')
    .pipe(cache('build:pug'))
    .pipe(pug({ data: {debug: true} }))
    .pipe(gulp.dest('dist/'))
}

function build_server() {
  return gulp.src('src/server/**/*.coffee')
    .pipe(cache('build:server'))
    .pipe(coffee({ bare: true }))
    .pipe(gulp.dest('dist/'))
}

function build_utils() {
  return gulp.src('src/utils/**/*.coffee')
    .pipe(cache('build:utils'))
    .pipe(coffee({ bare: true }))
    .pipe(gulp.dest('dist/utils/'))
}

function build_vue() {
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
    .pipe(gulp.dest('dist/')) // output dir
}

function test_unit() {
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
}
exports.test = test_unit

function watch_client() {
  gulp.watch('src/client/**/*', { interval: 500 }, build_client)
}


function watch_server() {
  gulp.watch('src/server/**/*.coffee', { interval: 500 }, build_server)
}

function watch_utils() {
  gulp.watch('src/utils/**/*.coffee', { interval: 500 }, build_utils)
}

const build_assets = gulp.series(build_assets_js, build_assets_img, build_assets_fonts);
exports.build_assets = build_assets;

const build_client = gulp.series(build_vue, build_pug, build_assets);
exports.build_client = build_client;

const build = gulp.series(clean, build_client, build_sass, build_utils, build_server);
exports.build = build;

const watch_parallel = gulp.parallel(watch_client, watch_utils, watch_server);

exports.default = gulp.series(build, watch_parallel);
