
# Dependencies
{assert} = require 'chai'
{pledge} = require '../../src/pledge'

suite 'Pass checking', ->

  suite "pledge('foo').isString().passes()", ->
    test 'should return `true`', ->
      assert.isTrue pledge('foo').isString().passes()

  suite "pledge('foo').isString().and.isDefined().passes()", ->
    test 'should return `true`', ->
      assert.isTrue pledge('foo').isString().and.isDefined().passes()

  suite "pledge('foo').isNumber().passes()", ->
    test 'should return `false`', ->
      assert.isFalse pledge('foo').isNumber().passes()

  suite "pledge('foo').isString().and.isNumber().passes()", ->
    test 'should return `false`', ->
      assert.isFalse pledge('foo').isString().and.isNumber().passes()

  suite "pledge('foo').either().isString().or.isNumber().passes()", ->
    test 'should return `true`', ->
      assert.isTrue pledge('foo').either().isString().or.isNumber().passes()

  suite "pledge(123).either().isString().or.isNumber().passes()", ->
    test 'should return `true`', ->
      assert.isTrue pledge(123).either().isString().or.isNumber().passes()

  suite "pledge(new Date()).isInstanceOf(Date).passes()", ->
    test 'should return `true`', ->
      assert.isTrue pledge(new Date()).isInstanceOf(Date).passes()

  suite "pledge(new Error()).isInstanceOf(Date).passes()", ->
    test 'should return `false`', ->
      assert.isFalse pledge(new Error()).isInstanceOf(Date).passes()

  suite "pledge(new Date()).isNotInstanceOf(Error).passes()", ->
    test 'should return `true`', ->
      assert.isTrue pledge(new Date()).isNotInstanceOf(Error).passes()

  suite "pledge(new Date()).either().isInstanceOf(Date).or.isInstanceOf(Error).passes()", ->
    test 'should return `true`', ->
      assert.isTrue pledge(new Date()).either().isInstanceOf(Date).or.isInstanceOf(Error).passes()

  suite "pledge(new Error()).either().isInstanceOf(Date).or.isInstanceOf(Error).passes()", ->
    test 'should return `true`', ->
      assert.isTrue pledge(new Error()).either().isInstanceOf(Date).or.isInstanceOf(Error).passes()

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
