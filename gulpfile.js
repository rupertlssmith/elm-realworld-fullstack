var gulp = require('gulp');
var chug = require('gulp-chug');
var gutil = require('gulp-util');

gulp.task('sleep', function(done) {
  gutil.log('Sleeping for 5000 milliseconds');
  setTimeout(done, 5000);
});

gulp.task('deploy_api_stack', function() {
  return gulp.src('./api/lambda/gulpfile.js')
    .pipe(chug({
      tasks: ['deploy_api_stack']
    }))
});

gulp.task('offline_api_stack', function() {
  return gulp.src('./api/lambda/gulpfile.js')
    .pipe(chug({
      tasks: ['offline_api_stack']
    }))
});

gulp.task('delete_offline_api_stack', function() {
  return gulp.src('./api/lambda/gulpfile.js')
    .pipe(chug({
      tasks: ['delete_offline_api_stack']
    }))
});

gulp.task('delete_api_stack', function() {
  return gulp.src('./api/lambda/gulpfile.js')
    .pipe(chug({
      tasks: ['delete_api_stack']
    }))
});

gulp.task('deploy', gulp.series(
  'deploy_api_stack',
  'sleep'
));

gulp.task('undeploy', gulp.series(
  'delete_api_stack'
));

gulp.task('offline', gulp.series(
  'offline_api_stack'
));

gulp.task('kill_offline', gulp.series(
  'delete_offline_api_stack'
));
