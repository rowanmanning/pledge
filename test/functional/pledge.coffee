
# Dependencies
{assert} = require 'chai'
{pledge} = require '../../src/pledge'

suite 'Pass checking', ->

  suite "pledge('foo').isString().passes()", ->
    test 'should return `true`', ->
      assert.isTrue pledge('foo').isString().passes()

  suite "pledge('foo').isString().isDefined().passes()", ->
    test 'should return `true`', ->
      assert.isTrue pledge('foo').isString().isDefined().passes()

  suite "pledge('foo').isNumber().passes()", ->
    test 'should return `false`', ->
      assert.isFalse pledge('foo').isNumber().passes()

  suite "pledge('foo').isString().isNumber().passes()", ->
    test 'should return `false`', ->
      assert.isFalse pledge('foo').isString().isNumber().passes()

  suite "pledge('foo').either().isString().isNumber().passes()", ->
    test 'should return `true`', ->
      assert.isTrue pledge('foo').either().isString().isNumber().passes()

  suite "pledge(123).either().isString().isNumber().passes()", ->
    test 'should return `true`', ->
      assert.isTrue pledge(123).either().isString().isNumber().passes()

suite 'Error checking', ->

  suite "pledge('foo').isString().otherwise.error('oops')", ->
    test 'should not throw an error', ->
      assert.doesNotThrow ->
        pledge('foo').isString().otherwise.error('oops')

  suite "pledge(123).isString().otherwise.error('oops')", ->
    test 'should throw an error', ->
      assert.throws ->
        pledge(123).isString().otherwise.error('oops')
      , /^oops$/