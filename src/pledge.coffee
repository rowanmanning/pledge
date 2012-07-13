###
Pledge - v0.2.0

Copyright 2012, Rowan Manning
Dual licensed under the MIT or GPL Version 2 licenses.
###

# Set up namespace
ns = {}

#>
# Utilities
# =========
#
ns.util =

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
    
    #>
    # Check whether an object is an array.
    #
    isArray: Array.isArray || (obj) ->
      ns.util.cast.toString(obj) is '[object Array]'
    
    #>
    # Check whether an object is a boolean.
    #
    isBoolean: (obj) ->
      typeof obj is 'boolean'
    
    #>
    # Check whether an object is a function.
    #
    isFunction: (obj) ->
      ns.util.cast.toString(obj) is '[object Function]'
    
    #>
    # Check whether an object is null.
    #
    isNull: (obj) ->
      obj is null
    
    #>
    # Check whether an object is a number.
    #
    isNumber: (obj) ->
      typeof obj is 'number'
    
    #>
    # Check whether an object is an object.
    #
    isObject: (obj) ->
      obj is Object(obj)
    
    #>
    # Check whether an object is a string.
    #
    isString: (obj) ->
      typeof obj is 'string'
    
    #>
    # Check whether an object is undefined.
    #
    isUndefined: (obj) ->
      typeof obj is 'undefined'
    
    #>
    # Check whether an object is a non-array.
    #
    isNotArray: (obj) ->
      not ns.util.type.isArray obj
    
    #>
    # Check whether an object is a non-boolean.
    #
    isNotBoolean: (obj) ->
      not ns.util.type.isBoolean obj
    
    #>
    # Check whether an object is a non-function.
    #
    isNotFunction: (obj) ->
      not ns.util.type.isFunction obj
    
    #>
    # Check whether an object is non-null.
    #
    isNotNull: (obj) ->
      not ns.util.type.isNull obj
    
    #>
    # Check whether an object is a non-number.
    #
    isNotNumber: (obj) ->
      not ns.util.type.isNumber obj
    
    #>
    # Check whether an object is a non-object.
    #
    isNotObject: (obj) ->
      not ns.util.type.isObject obj
    
    #>
    # Check whether an object is a non-string.
    #
    isNotString: (obj) ->
      not ns.util.type.isString obj
    
    #>
    # Check whether an object is defined.
    #
    isDefined: (obj) ->
      not ns.util.type.isUndefined obj

  #>
  # Instance checking
  # ------------
  #
  instance:

    #>
    # Check whether an object is a instance of a prototypal class.
    #
    isInstanceOf: (obj, proto) ->
      if typeof proto isnt 'function'
        return false
      obj instanceof proto

    #>
    # Check whether an object is not an instance of a prototypal class.
    #
    isNotInstanceOf: (obj, proto) ->
      not ns.util.instance.isInstanceOf obj, proto

#>
# Test class
# ==========
#
# Represents a pledge test.
# @class pledge.Test
#
class ns.Test

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
  # @argument+ {mixed} args...
  # @return {Boolean}
  #
  assert: (fn, args...) ->
    if typeof fn isnt 'function'
      throw new Error 'Invalid fn argument, function expected'
    args.unshift @getSubject()
    result = fn.apply this, args
    pass = if typeof result is 'boolean' then result else false
    @_results.push pass
    pass

  # Mix in type-checking utilities
  for own name, fn of ns.util.type
    do (name) =>
      @::[name] = ->
        @assert ns.util.type[name]

  # Mix in instance checking utilities
  for own name, fn of ns.util.instance
    do (name) =>
      @::[name] = (proto) ->
        @assert ns.util.instance[name], proto

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
class ns.TestChain extends ns.Test

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
    @setLogicMode ns.Test.LOGIC_MODE_AND
    this

  #>
  # Set the assertion logic mode to 'or'.
  # @method pledge.TestChain::either
  # @return {pledge.TestChain}
  #
  either: ->
    @setLogicMode ns.Test.LOGIC_MODE_OR
    this

  #>
  # Assert that a function will return true when called with the test subject.
  # @method pledge.TestChain::assert
  # @return {pledge.TestChain}
  # @see pledge.Test::assert
  #
  assert: () ->
    super
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
ns.pledge = (subject) ->
  if this instanceof ns.pledge
    throw new Error 'Bad method call, unexpected `new`'
  new ns.TestChain subject


# Exports for browser
if not module? and typeof window isnt 'undefined'

  # Expose `pledge` on the window object
  window.pledge = ns.pledge

  # Expose `util` as a property of `pledge` so as
  # not to pollute the global namespace
  window.pledge.util = ns.util

# Exports for Node
else
  module.exports = ns
