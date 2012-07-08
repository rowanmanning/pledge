
#>
# Utilities
# =========
#
exports.util =

  #>
  # Type casting
  # ------------
  #
  cast:

    #>
    # Convert an object to a string
    # @function pledge.util.cast.toString
    # @argument+ {mixed} obj
    # @return {String}
    #
    toString: (obj) ->
      Object.prototype.toString.call obj

  #>
  # Type checking
  # ------------
  #
  type:
    isArray: Array.isArray || (obj) ->
      exports.util.cast.toString(obj) is '[object Array]'
    isBoolean: (obj) ->
      typeof obj is 'boolean'
    isFunction: (obj) ->
      exports.util.cast.toString(obj) is '[object Function]'
    isNull: (obj) ->
      obj is null
    isNumber: (obj) ->
      typeof obj is 'number'
    isObject: (obj) ->
      obj is Object(obj)
    isString: (obj) ->
      typeof obj is 'string'
    isUndefined: (obj) ->
      typeof obj is 'undefined'
    isNotArray: (obj) ->
      not exports.util.type.isArray obj
    isNotBoolean: (obj) ->
      not exports.util.type.isBoolean obj
    isNotFunction: (obj) ->
      not exports.util.type.isFunction obj
    isNotNull: (obj) ->
      not exports.util.type.isNull obj
    isNotNumber: (obj) ->
      not exports.util.type.isNumber obj
    isNotObject: (obj) ->
      not exports.util.type.isObject obj
    isNotString: (obj) ->
      not exports.util.type.isString obj
    isDefined: (obj) ->
      not exports.util.type.isUndefined obj

#>
# Test class
# ==========
#
# Represents a pledge test.
# @class pledge.Test
#
class exports.Test

  # Test logic mode constants
  @LOGIC_MODE_AND = 'and'
  @LOGIC_MODE_OR = 'or'

  #>
  # Class constructor.
  # @method pledge.Test::constructor
  # @argument+ {mixed} subject
  #
  constructor: (subject) ->
    if this not instanceof Test
      throw new Error 'Bad construction, missing `new`'
    @_subject = subject
    @_logicMode = Test.LOGIC_MODE_AND
    @_results = []

  #>
  # Get the assertion subject.
  # @method pledge.Test::getSubject
  # @return {String}
  #
  getSubject: -> @_subject

  #>
  # Set the assertion logic mode.
  # @method pledge.Test::setLogicMode
  # @argument+ {String} logicMode
  #
  setLogicMode: (logicMode) ->
    if @_results.length > 0
      throw new Error 'Logic mode cannot be changed once assertions have been made'
    if logicMode not in [Test.LOGIC_MODE_AND, Test.LOGIC_MODE_OR]
      throw new Error 'Invalid logic mode'
    @_logicMode = logicMode

  #>
  # Get the assertion logic mode.
  # @method pledge.Test::getLogicMode
  # @return {String}
  #
  getLogicMode: -> @_logicMode

  #>
  # Assert that a function will return true when called with the test subject.
  # @method pledge.Test::assert
  # @argument+ {Function} fn
  # @return {Boolean}
  #
  assert: (fn) ->
    if typeof fn isnt 'function'
      throw new Error 'Invalid fn argument, function expected'
    result = fn @getSubject()
    pass = if typeof result is 'boolean' then result else false
    @_results.push pass
    pass

  # Mix in type-checking utilities
  for own name, fn of exports.util.type
    @::[name] = -> @assert fn

  #>
  # Check whether the assertion passes.
  # @method pledge.Test::passes
  # @return {Boolean}
  #
  passes: ->
    if @_results.length is 0
      true
    else if @getLogicMode() is Test.LOGIC_MODE_AND
      false not in @_results
    else
      true in @_results

#>
# Test Chain class
# =====================
#
# A convenience wrapper for `Test`.
# @class pledge.TestChain
#
class exports.TestChain extends exports.Test

  #>
  # Class constructor.
  # @method pledge.TestChain::constructor
  # @see pledge.Test::constructor
  #
  constructor: (subject) ->
    super subject
    @otherwise = @and = @or = this

  #>
  # Set the assertion logic mode to 'and'.
  # @method pledge.TestChain::all
  # @return {pledge.TestChain}
  #
  all: ->
    @setLogicMode exports.Test.LOGIC_MODE_AND
    this

  #>
  # Set the assertion logic mode to 'or'.
  # @method pledge.TestChain::either
  # @return {pledge.TestChain}
  #
  either: ->
    @setLogicMode exports.Test.LOGIC_MODE_OR
    this

  #>
  # Assert that a function will return true when called with the test subject.
  # @method pledge.TestChain::assert
  # @return {pledge.TestChain}
  # @see pledge.Test::assert
  #
  assert: (fn) ->
    super fn
    this

  #>
  # Throw an error if the assertion does not pass.
  # @method pledge.TestChain::error
  # @argument+ {Error|String} object
  # @return {pledge.TestChain}
  #
  error: (object) ->
    if object not instanceof Error and typeof object isnt 'string'
      throw new Error 'Invalid object argument, Error or string expected'
    if not @passes()
      if typeof object is 'string'
        throw new Error object
      else
        throw object
    this

#>
# Test factory
# =================
#
# Shortcut constructor for `TestChain`.
#
exports.pledge = (subject) ->
  if this instanceof exports.pledge
    throw new Error 'Bad method call, unexpected `new`'
  new exports.TestChain subject
