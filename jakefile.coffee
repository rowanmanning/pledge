
# Dependencies
colors = require 'colors'
{exec} = require 'child_process'

# Paths
paths =
  nodebin: './node_modules/.bin',
  unitTest: './test/unit'

# Build JavaScript
desc 'This builds JavaScript from the CoffeeScript source'
task 'build', ->
  console.log 'Building JavaScript:'.cyan
  exec "#{paths.nodebin}/coffee -o ./lib ./src", (error, stdout, stderr) ->
    console.log (if error is null then stdout else stderr)

# Run unit tests
desc 'This runs all unit tests'
task 'test', ->
  console.log 'Running tests:'.cyan
  exec getTestCommand(), (error, stdout, stderr) ->
    console.log (if error is null then stdout else stderr)

# Generate a test command
getTestCommand = (options = {}) ->
  options.ui ?= 'tdd'
  options.reporter ?= 'spec'
  "#{paths.nodebin}/mocha --compilers coffee:coffee-script --ui #{options.ui} --reporter #{options.reporter} --colors #{paths.unitTest}/**";
