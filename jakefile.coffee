
# Dependencies
colors = require 'colors'
{exec} = require 'child_process'

# Paths
paths =
  nodebin: './node_modules/.bin'
  unitTest: './test/unit'
  functionalTest: './test/functional'

# Build JavaScript
desc 'This builds JavaScript from the CoffeeScript source'
task 'build', ->
  console.log 'Building JavaScript:'.cyan
  exec "#{paths.nodebin}/coffee -o ./lib ./src", (error, stdout, stderr) ->
    console.log (if error is null then stdout else stderr)

# Run unit tests
desc 'This runs all unit tests'
task 'test', ->
  console.log 'Running unit tests:'.cyan
  exec getTestCommand(), (error, stdout, stderr) ->
    console.log (if error is null then stdout else stderr)

# Run functional tests
desc 'This runs all functional tests'
task 'functional', ->
  console.log 'Running functional tests:'.cyan
  exec getTestCommand(dir: paths.functionalTest), (error, stdout, stderr) ->
    console.log (if error is null then stdout else stderr)

# Generate a test command
getTestCommand = (options = {}) ->
  options.ui ?= 'tdd'
  options.reporter ?= 'spec'
  options.dir ?= paths.unitTest
  "#{paths.nodebin}/mocha --compilers coffee:coffee-script --ui #{options.ui} --reporter #{options.reporter} --colors #{options.dir}/**";
