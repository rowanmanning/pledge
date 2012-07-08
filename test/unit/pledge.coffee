
# Dependencies
{assert} = require 'chai'
sinon = require 'sinon'

# Assertion methods
assertionMethods = [
  'isArray'
  'isBoolean'
  'isFunction'
  'isNull'
  'isNumber'
  'isObject'
  'isString'
  'isUndefined'
  'isNotArray'
  'isNotBoolean'
  'isNotFunction'
  'isNotNull'
  'isNotNumber'
  'isNotObject'
  'isNotString'
  'isDefined'
]

# Tests
suite 'pledge module', ->
  module = require '../../src/pledge'

  test 'should be an object', ->
    assert.isObject module

  test 'should have a `Test` property', ->
    assert.isDefined module.Test

  test 'should have a `TestChain` property', ->
    assert.isDefined module.TestChain

  test 'should have a `pledge` property', ->
    assert.isDefined module.pledge

  suite '`Test` property', ->

    test 'should be a function', ->
      assert.isFunction module.Test

    test 'should have a `LOGIC_MODE_AND` property', ->
      assert.isDefined module.Test.LOGIC_MODE_AND

    test 'should have a `LOGIC_MODE_OR` property', ->
      assert.isDefined module.Test.LOGIC_MODE_OR

    test 'should have a prototype `getSubject` method', ->
      assert.isFunction module.Test::getSubject

    test 'should have a prototype `setLogicMode` method', ->
      assert.isFunction module.Test::setLogicMode

    test 'should have a prototype `getLogicMode` method', ->
      assert.isFunction module.Test::getLogicMode

    test 'should have a prototype `assert` method', ->
      assert.isFunction module.Test::assert

    test 'should have a prototype `passes` method', ->
      assert.isFunction module.Test::passes

    # Test assertion methods – loop used for brevity
    for assertionMethod in assertionMethods
      do (assertionMethod) ->
        test "should have a prototype `#{assertionMethod}` method", ->
          assert.isFunction module.Test::[assertionMethod]

    test 'should throw when called without the `new` keyword', ->
      assert.throws -> module.Test()

    test 'should not throw when constructed regardless of arguments', ->
      assert.doesNotThrow -> new module.Test()
      assert.doesNotThrow -> new module.Test 'foo'
      assert.doesNotThrow -> new module.Test []
      assert.doesNotThrow -> new module.Test {}

    suite 'instance', ->
      instance = null
      assertionFn = null

      setup ->
        instance = new module.Test()
        assertionFn = sinon.spy()

      teardown ->
        instance = null
        assertionFn = null

      test '`getSubject` method should return `undefined`', ->
        assert.isUndefined instance.getSubject()

      test '`getLogicMode` method should return the value of `Test.LOGIC_MODE_AND`', ->
        assert.strictEqual instance.getLogicMode(), module.Test.LOGIC_MODE_AND

      test '`setLogicMode` method should not throw when called with `Test.LOGIC_MODE_AND`', ->
        assert.doesNotThrow -> instance.setLogicMode module.Test.LOGIC_MODE_AND

      test '`setLogicMode` method should not throw when called with `Test.LOGIC_MODE_OR`', ->
        assert.doesNotThrow -> instance.setLogicMode module.Test.LOGIC_MODE_OR

      test '`setLogicMode` method should throw when called with any other argument', ->
        assert.throws -> instance.setLogicMode 'foo'
        assert.throws -> instance.setLogicMode 123
        assert.throws -> instance.setLogicMode {}

      test '`assert` method should not throw when called with a function argument', ->
        assert.doesNotThrow -> instance.assert ->

      test '`assert` method should throw when called with a non-function argument', ->
        assert.throws -> instance.assert {}

      test '`assert` method should return a boolean', ->
        assert.isBoolean instance.assert(->)

      test '`assert` method should call the passed in function', ->
        instance.assert(assertionFn)
        assert.isTrue assertionFn.called

      test '`assert` method should return `true` when the assertion function returns `true`', ->
        assert.isTrue instance.assert(-> true)

      test '`assert` method should return `false` when the assertion function returns `false`', ->
        assert.isFalse instance.assert(-> false)

      test '`assert` method should return `false` when the assertion function returns a non-boolean value', ->
        assert.isFalse instance.assert(-> 'foo')

      test '`passes` method should return `true`', ->
        assert.isTrue instance.passes()

      suite 'assertion methods', ->

        setup ->
          sinon.spy instance, 'assert'

        teardown ->
          instance.assert.restore()

        # Test assertion methods – loop used for brevity
        for assertionMethod in assertionMethods
          do (assertionMethod) ->
            test "`#{assertionMethod}` method should call the `assert` method", ->
              instance[assertionMethod]()
              instance.assert.called

    suite 'instance with a subject specified', ->
      instance = null
      assertionFunction = null

      setup ->
        instance = new module.Test 'foo'
        assertionFunction = sinon.spy()

      teardown ->
        instance = null
        assertionFunction = null

      test '`getSubject` method should return the value passed into the constructor', ->
        assert.strictEqual instance.getSubject(), 'foo'

      test '`assert` method should call the passed in function with the test subject as a first argument', ->
        instance.assert(assertionFunction)
        assert.isTrue assertionFunction.calledWith('foo')

    suite 'instance with logic mode set to `Test.LOGIC_MODE_AND`', ->
      instance = null

      setup ->
        instance = new module.Test
        instance.setLogicMode module.Test.LOGIC_MODE_AND

      teardown ->
        instance = null

      test '`getLogicMode` method should return the value of `Test.LOGIC_MODE_AND`', ->
        assert.strictEqual instance.getLogicMode(), module.Test.LOGIC_MODE_AND

    suite 'instance with logic mode set to `Test.LOGIC_MODE_OR`', ->
      instance = null

      setup ->
        instance = new module.Test
        instance.setLogicMode module.Test.LOGIC_MODE_OR

      teardown ->
        instance = null

      test '`getLogicMode` method should return the value of `Test.LOGIC_MODE_OR`', ->
        assert.strictEqual instance.getLogicMode(), module.Test.LOGIC_MODE_OR

    suite 'instance with assertions', ->
      instance = null

      setup ->
        instance = new module.Test 'foo'
        instance.assert -> true

      teardown ->
        instance = null

      test '`setLogicMode` method should throw when called with valid arguments', ->
        assert.throws -> instance.setLogicMode module.Test.LOGIC_MODE_AND

    suite 'instance with logic mode set to `Test.LOGIC_MODE_AND` and assertions that return both `true` and `false`', ->
      instance = null
      assertionFn = null

      setup ->
        instance = new module.Test
        instance.setLogicMode module.Test.LOGIC_MODE_AND
        instance.assert -> true
        instance.assert -> false

      teardown ->
        instance = null

      test '`passes` method should return `false`', ->
        assert.isFalse instance.passes()

    suite 'instance with logic mode set to `Test.LOGIC_MODE_AND` and assertions that return only `true`', ->
      instance = null
      assertionFn = null

      setup ->
        instance = new module.Test
        instance.setLogicMode module.Test.LOGIC_MODE_AND
        instance.assert -> true
        instance.assert -> true

      teardown ->
        instance = null

      test '`passes` method should return `true`', ->
        assert.isTrue instance.passes()

    suite 'instance with logic mode set to `Test.LOGIC_MODE_AND` and assertions that return only `false`', ->
      instance = null
      assertionFn = null

      setup ->
        instance = new module.Test
        instance.setLogicMode module.Test.LOGIC_MODE_AND
        instance.assert -> false
        instance.assert -> false

      teardown ->
        instance = null

      test '`passes` method should return `false`', ->
        assert.isFalse instance.passes()

    suite 'instance with logic mode set to `Test.LOGIC_MODE_OR` and assertions that return both `true` and `false`', ->
      instance = null
      assertionFn = null

      setup ->
        instance = new module.Test
        instance.setLogicMode module.Test.LOGIC_MODE_OR
        instance.assert -> true
        instance.assert -> false

      teardown ->
        instance = null

      test '`passes` method should return `true`', ->
        assert.isTrue instance.passes()

    suite 'instance with logic mode set to `Test.LOGIC_MODE_OR` and assertions that return only `true`', ->
      instance = null
      assertionFn = null

      setup ->
        instance = new module.Test
        instance.setLogicMode module.Test.LOGIC_MODE_OR
        instance.assert -> true
        instance.assert -> true

      teardown ->
        instance = null

      test '`passes` method should return `true`', ->
        assert.isTrue instance.passes()

    suite 'instance with logic mode set to `Test.LOGIC_MODE_OR` and assertions that return only `false`', ->
      instance = null
      assertionFn = null

      setup ->
        instance = new module.Test
        instance.setLogicMode module.Test.LOGIC_MODE_OR
        instance.assert -> false
        instance.assert -> false

      teardown ->
        instance = null

      test '`passes` method should return `false`', ->
        assert.isFalse instance.passes()

  suite '`TestChain` property', ->

    test 'should be a function', ->
      assert.isFunction module.TestChain

    test 'should extend the `Test` prototype', ->
      assert.instanceOf module.TestChain.prototype, module.Test

    test 'should have a prototype `all` method', ->
      assert.isFunction module.TestChain::all

    test 'should have a prototype `either` method', ->
      assert.isFunction module.TestChain::either

    test 'should have a prototype `error` method', ->
      assert.isFunction module.TestChain::error

    suite 'instance', ->
      instance = null

      setup ->
        instance = new module.TestChain()

      teardown ->
        instance = null

      test 'should have an `otherwise` property', ->
        assert.isDefined instance.otherwise

      test 'should have an `and` property', ->
        assert.isDefined instance.and

      test 'should have an `or` property', ->
        assert.isDefined instance.or

      test '`all` method should not throw', ->
        assert.doesNotThrow -> instance.all()

      test '`all` method should be chainable', ->
        assert.strictEqual instance.all(), instance

      test '`either` method should not throw', ->
        assert.doesNotThrow -> instance.either()

      test '`either` method should be chainable', ->
        assert.strictEqual instance.either(), instance

      test '`otherwise` property should alias the instance', ->
        assert.strictEqual instance.otherwise, instance

      test '`and` property should alias the instance', ->
        assert.strictEqual instance.and, instance

      test '`or` property should alias the instance', ->
        assert.strictEqual instance.or, instance

      test '`assert` method should be chainable', ->
        assert.strictEqual instance.assert(-> true), instance

    suite 'instance with `all` called', ->
      instance = null

      setup ->
        instance = new module.TestChain()
        sinon.spy instance, 'setLogicMode'
        instance.all()

      teardown ->
        instance.setLogicMode.restore()
        instance = null

      test '`setLogicMode` method should be called', ->
        assert.isTrue instance.setLogicMode.called

      test '`setLogicMode` should be called with `Test.LOGIC_MODE_AND`', ->
        assert.isTrue instance.setLogicMode.calledWith(module.Test.LOGIC_MODE_AND)

    suite 'instance with `either` called', ->
      instance = null

      setup ->
        instance = new module.TestChain()
        sinon.spy instance, 'setLogicMode'
        instance.either()

      teardown ->
        instance.setLogicMode.restore()
        instance = null

      test '`setLogicMode` method should be called', ->
        assert.isTrue instance.setLogicMode.called

      test '`setLogicMode` should be called with `Test.LOGIC_MODE_OR`', ->
        assert.isTrue instance.setLogicMode.calledWith(module.Test.LOGIC_MODE_OR)

    suite 'instance which passes', ->
      instance = null

      setup ->
        instance = new module.TestChain()
        sinon.stub instance, 'passes', -> true
        instance.either()

      teardown ->
        instance.passes.restore()
        instance = null

      test '`error` method should not throw when called with an Error object', ->
        assert.doesNotThrow -> instance.error new Error('foo')

      test '`error` method should not throw when called with a string', ->
        assert.doesNotThrow -> instance.error 'foo'

      test '`error` method should throw when called with a non-string/non-Error argument', ->
        assert.throws -> instance.error {}

      test '`error` method should be chainable', ->
        assert.strictEqual instance.error('foo'), instance

    suite 'instance which does not pass', ->
      instance = null

      setup ->
        instance = new module.TestChain()
        sinon.stub instance, 'passes', -> false
        instance.either()

      teardown ->
        instance.passes.restore()
        instance = null

      test '`error` method should throw the passed in Error object when called with an Error object', ->
        assert.throws ->
          instance.error new Error('foo')
        , /^foo$/

      test '`error` method should throw an Error with the passed in string as a message when called with a string', ->
        assert.throws ->
          instance.error 'bar'
        , /^bar$/

  suite '`pledge` property', ->
    property = module.pledge

    test 'should be a function', ->
      assert.isFunction property

    test 'should throw when called with the `new` keyword', ->
      assert.throws -> new module.pledge()

    test 'should not throw when called regardless of arguments', ->
      assert.doesNotThrow -> module.pledge()
      assert.doesNotThrow -> module.pledge 'foo'
      assert.doesNotThrow -> module.pledge []
      assert.doesNotThrow -> module.pledge {}

    test 'should return an `TestChain` object', ->
      assert.instanceOf module.pledge(), module.TestChain

    suite 'Call with subject \'foo\'', ->
      instance = null

      setup ->
        sinon.spy module, 'TestChain'
        instance = module.pledge 'foo'

      teardown ->
        module.TestChain.restore()
        instance = null

      test '`TestChain` should be called', ->
        assert.isTrue module.TestChain.called

      test '`TestChain` should be called with the `new` keyword', ->
        assert.isTrue module.TestChain.calledWithNew()

      test '`TestChain` should be called with the same first argument as the original call', ->
        assert.isTrue module.TestChain.calledWith('foo')
