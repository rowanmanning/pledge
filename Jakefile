'use strict';


// Dependencies
var colors = require('colors');
var exec = require('child_process').exec;


// Config
var nodebin = 'node ./node_modules/.bin';


// Utils/aliases
var log = console.log;
log.task = function (msg) {
    log((msg + ':').cyan);
}


// Run jshint on the source code
function lint () {
    log.task('Lint');
    exec(nodebin + '/jshint --config ./test/config/jshint.json ./test ./lib', function (err, stdout, stderr) {
        if (err !== null) {
            log(stdout);
            fail()
        } else {
            log('No errors'.green);
        }
        log('');
        complete();
    });
}

// Run unit tests
function test () {
    log.task('Test');
    exec(nodebin + '/mocha --ui tdd --reporter spec --colors --recursive ./test/unit', function (err, stdout, stderr) {
        if (err !== null) {
            log(stderr);
            fail()
        } else {
            log(stdout);
        }
        log('');
        complete();
    });
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
