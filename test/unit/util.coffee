
# Dependencies
{assert} = require 'chai'
sinon = require 'sinon'

# Tests
suite 'pledge module utilities', ->
  module = require '../../src/pledge'

  test 'should be an object', ->
    assert.isObject module.util

  test 'should have a `cast` property', ->
    assert.isDefined module.util.cast

  suite '`cast` property', ->
    cast = module.util.cast

    test 'should be an object', ->
      assert.isObject cast

    test 'should have a `toString` function', ->
      assert.isFunction cast.toString

    suite '`toString` function', ->
      toString = cast.toString

      test 'should not throw regardless of arguments', ->
        assert.doesNotThrow -> toString 'foo'
        assert.doesNotThrow -> toString 123
        assert.doesNotThrow -> toString {}

      suite 'call with `123`', ->
        result = null

        setup ->
          sinon.spy Object.prototype, 'toString'
          result = toString 123

        teardown ->
          Object.prototype.toString.restore()
          result = null

        test 'should call `String.prototype.toString`', ->
          assert.isTrue Object.prototype.toString.called

        test 'should call `String.prototype.toString` with `123` as a context', ->
          assert.isTrue Object.prototype.toString.calledOn 123

  test 'should have a `type` property', ->
    assert.isDefined module.util.type

  suite '`type` property', ->
    type = module.util.type

    test 'should be an object', ->
      assert.isObject type

    # Test type checking functions – loop used for brevity
    typeFunctionTests =
      isArray:
        name: 'array'
        yes: [[], new Array()]
        no: [undefined, null, true, 'foo', 123, {}, new Date(), ->]
      isBoolean:
        name: 'boolean'
        yes: [true, false]
        no: [undefined, null, 'foo', 123, [], {}, new Date(), ->]
      isFunction:
        name: 'function'
        yes: [Date, ->]
        no: [undefined, null, true, 'foo', 123, [], {}, new Date()]
      isNull:
        name: 'null'
        yes: [null]
        no: [undefined, true, 'foo', 123, [], {}, new Date(), ->]
      isNumber:
        name: 'number'
        yes: [123, 12.3, Infinity, NaN]
        no: [undefined, null, true, 'foo', [], {}, new Date(), ->]
      isObject:
        name: 'object'
        yes: [[], {}, new Date(), ->]
        no: [undefined, null, true, 'foo', 123]
      isString:
        name: 'string'
        yes: ['foo']
        no: [undefined, null, true, 123, [], {}, new Date(), ->]
      isUndefined:
        name: 'undefined'
        yes: [undefined]
        no: [null, true, 'foo', 123, [], {}, new Date(), ->]
      isNotArray:
        name: 'non-array'
        yes: [undefined, null, true, 'foo', 123, {}, new Date(), ->]
        no: [[], new Array()]
      isNotBoolean:
        name: 'non-boolean'
        yes: [undefined, null, 'foo', 123, [], {}, new Date(), ->]
        no: [true, false]
      isNotFunction:
        name: 'non-function'
        yes: [undefined, null, true, 'foo', 123, [], {}, new Date()]
        no: [Date, ->]
      isNotNull:
        name: 'non-null'
        yes: [undefined, true, 'foo', 123, [], {}, new Date(), ->]
        no: [null]
      isNotNumber:
        name: 'non-number'
        yes: [undefined, null, true, 'foo', [], {}, new Date(), ->]
        no: [123, 12.3, Infinity, NaN]
      isNotObject:
        name: 'non-object'
        yes: [undefined, null, true, 'foo', 123]
        no: [[], {}, new Date(), ->]
      isNotString:
        name: 'non-string'
        yes: [undefined, null, true, 123, [], {}, new Date(), ->]
        no: ['foo']
      isDefined:
        name: 'defined'
        yes: [null, true, 'foo', 123, [], {}, new Date(), ->]
        no: [undefined]
    for own functionName, testData of typeFunctionTests
      do (functionName, testData) ->

        test "should have an `#{functionName}` function", ->
          assert.isFunction type[functionName]

        suite "`#{functionName}` function", ->

          test 'should not throw regardless of arguments', ->
            assert.doesNotThrow -> type[functionName]()
            assert.doesNotThrow -> type[functionName] null
            assert.doesNotThrow -> type[functionName] true
            assert.doesNotThrow -> type[functionName] 'foo'
            assert.doesNotThrow -> type[functionName] 123
            assert.doesNotThrow -> type[functionName] []
            assert.doesNotThrow -> type[functionName] {}
            assert.doesNotThrow -> type[functionName] ->
            assert.doesNotThrow -> type[functionName] new Date()

          test "should return true when called with #{testData.name} argument", ->
            for obj in testData.yes
              assert.isTrue type[functionName](obj)

          test "should return false when called with non-#{testData.name} argument", ->
            for obj in testData.no
              assert.isFalse type[functionName](obj)
