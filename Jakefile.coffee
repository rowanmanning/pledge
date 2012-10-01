
# Dependencies
colors = require 'colors'
{exec} = require 'child_process'

# Paths
paths =
  config: './test/config'
  dist: './dist'
  functionalTest: './test/functional'
  lib: './lib'
  nodebin: './node_modules/.bin'
  src: './src'
  unitTest: './test/unit'

# Build JavaScript
desc 'This builds JavaScript from the CoffeeScript source'
task 'build', ['lint', 'test', 'functional'], ->
  console.log 'Building JavaScript:'.cyan
  exec "#{paths.nodebin}/coffee -o #{paths.lib} #{paths.src}", (error, stdout, stderr) ->
    if error is null
      console.log 'Built!'.green
    else
      console.log stderr
      process.exit()
    complete()
, async: true

# Build Distribution JavaScript
desc 'This builds distribution JavaScript from the JavaScript source'
task 'dist', ['build'], ->
  console.log 'Building distribution JavaScript:'.cyan
  exec "mkdir -p #{paths.dist} && cp #{paths.lib}/pledge.js #{paths.dist}/", (error, stdout, stderr) ->
    if error is null
      console.log 'Unminified version built!'.green
      exec "#{paths.nodebin}/uglifyjs -o #{paths.dist}/pledge.min.js #{paths.dist}/pledge.js", (error, stdout, stderr) ->
      if error is null
        console.log 'Minified version built!'.green
      else
        console.log stderr
        process.exit()
      complete()
    else
      console.log stderr
      process.exit()
, async: true

# Run CoffeeLint
desc 'This runs CoffeeLint on the CoffeeScript source'
task 'lint', ->
  console.log 'Linting:'.cyan
  exec getLintCommand(), (error, stdout, stderr) ->
    if stderr is ''
      console.log stdout
    else
      console.log stderr
      process.exit()
    complete()
, async: true

# Run unit tests
desc 'This runs all unit tests'
task 'test', ->
  console.log 'Running unit tests:'.cyan
  exec getTestCommand(), (error, stdout, stderr) ->
    if error is null
      console.log stdout
    else
      console.log stderr
      process.exit()
    complete()
, async: true

# Run functional tests
desc 'This runs all functional tests'
task 'functional', ->
  console.log 'Running functional tests:'.cyan
  exec getTestCommand(dir: paths.functionalTest), (error, stdout, stderr) ->
    if error is null
      console.log stdout
    else
      console.log stderr
      process.exit()
    complete()
, async: true

# CI
desc 'This runs all tasks required for CI'
task 'ci', ['lint', 'test']

# Default task
task 'default', ['build']

# Generate a lint command
getLintCommand = (options = {}) ->
  options.configFile ?= "#{paths.config}/coffeelint.json"
  "#{paths.nodebin}/coffeelint -rf #{options.configFile} #{paths.src} #{paths.unitTest} #{paths.functionalTest}"

# Generate a test command
getTestCommand = (options = {}) ->
  options.ui ?= 'tdd'
  options.reporter ?= 'spec'
  options.dir ?= paths.unitTest
  "#{paths.nodebin}/mocha --compilers coffee:coffee-script --ui #{options.ui} --reporter #{options.reporter} --colors #{options.dir}/**";
