
# Dependencies
{assert} = require 'chai'

# Tests
suite 'pledge module', ->
  module = require '../../src/pledge'

  test 'should be an object', ->
    assert.isObject module
