'use strict';


// Dependencies
var colors = require('colors');


// Utils/aliases
var log = console.log;
log.task = function (msg) {
    log((msg + ':').cyan);
}


// Run jshint on the source code
function lint () {
    log.task('Lint');
    log();
    complete();
}

// Run unit tests
function test () {
    log.task('Test');
    log();
    complete();
}


// Register tasks

desc('This runs jshint on the source code');
task('lint', lint, {async: true});

desc('This runs all unit tests');
task('test', test, {async: true});

desc('This runs all tasks required for CI');
task('ci', ['lint', 'test']);

task('default', ['ci', 'build']);


// Pre/post task boilerplate
log('\nPledge build tool\n'.blue.underline);
jake.addListener('complete', function () {
    log('');
});
