
# Dependencies
colors = require 'colors'
{exec} = require 'child_process'

# Paths
paths =
  config: './config'
  nodebin: './node_modules/.bin'
  functionalTest: './test/functional'
  src: './src'
  unitTest: './test/unit'

# Build JavaScript
desc 'This builds JavaScript from the CoffeeScript source'
task 'build', ->
  console.log 'Building JavaScript:'.cyan
  exec "#{paths.nodebin}/coffee -o ./lib ./src", (error, stdout, stderr) ->
    console.log (if error is null then stdout else stderr)

# Run CoffeeLint
desc 'This runs CoffeeLint on the CoffeeScript source'
task 'lint', ->
  console.log 'Linting:'.cyan
  exec getLintCommand(), (error, stdout, stderr) ->
    console.log (if stderr is '' then stdout else stderr)

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

# Generate a lint command
getLintCommand = (options = {}) ->
  options.configFile ?= "#{paths.config}/coffeelint.json"
  "#{paths.nodebin}/coffeelint -f #{options.configFile} {#{paths.src},#{paths.unitTest},#{paths.functionalTest}}/**";

# Generate a test command
getTestCommand = (options = {}) ->
  options.ui ?= 'tdd'
  options.reporter ?= 'spec'
  options.dir ?= paths.unitTest
  "#{paths.nodebin}/mocha --compilers coffee:coffee-script --ui #{options.ui} --reporter #{options.reporter} --colors #{options.dir}/**";
