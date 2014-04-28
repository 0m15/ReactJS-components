var gulp = require('gulp');

var coffee = require('gulp-coffee');
var concat = require('gulp-concat');
var uglify = require('gulp-uglify');
var imagemin = require('gulp-imagemin');
var browserify = require('gulp-browserify');
var rename = require('gulp-rename');

var paths = {
  scripts: ['app/components/**/*.coffee',]
};

// gulp.task('scripts', function() {
//   // Minify and copy all JavaScript (except vendor scripts)
//   return gulp.src(paths.scripts)
//     .pipe(coffee({bare: true}))
//     .pipe(concat('all.js'))
//     .pipe(gulp.dest('build/js'));
// });

gulp.task('coffee', function() {
  gulp.src('app/components/examples/index.coffee', { read: false })
    .pipe(browserify({
      transform: ['coffeeify', 'reactify'],
      extensions: ['.coffee']
    }))
    .pipe(rename('all.js'))
    .pipe(gulp.dest('./build/js'))
});

// Rerun the task when a file changes
gulp.task('watch', function() {
  gulp.watch(paths.scripts, ['coffee']);
  gulp.watch(paths.images, ['images']);
});

// The default task (called when you run `gulp` from cli)
gulp.task('default', ['coffee', 'watch']);
