// Generated by CoffeeScript 1.3.3

/*
Pledge - v0.2.0

Copyright 2012, Rowan Manning
Dual licensed under the MIT or GPL Version 2 licenses.
*/


(function() {
  var ns,
    __slice = [].slice,
    __hasProp = {}.hasOwnProperty,
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; },
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  ns = {};

  ns.util = {
    cast: {
      toString: function(obj) {
        return Object.prototype.toString.call(obj);
      }
    },
    type: {
      isArray: Array.isArray || function(obj) {
        return ns.util.cast.toString(obj) === '[object Array]';
      },
      isBoolean: function(obj) {
        return typeof obj === 'boolean';
      },
      isFunction: function(obj) {
        return ns.util.cast.toString(obj) === '[object Function]';
      },
      isNull: function(obj) {
        return obj === null;
      },
      isNumber: function(obj) {
        return typeof obj === 'number';
      },
      isObject: function(obj) {
        return obj === Object(obj);
      },
      isString: function(obj) {
        return typeof obj === 'string';
      },
      isUndefined: function(obj) {
        return typeof obj === 'undefined';
      },
      isNotArray: function(obj) {
        return !ns.util.type.isArray(obj);
      },
      isNotBoolean: function(obj) {
        return !ns.util.type.isBoolean(obj);
      },
      isNotFunction: function(obj) {
        return !ns.util.type.isFunction(obj);
      },
      isNotNull: function(obj) {
        return !ns.util.type.isNull(obj);
      },
      isNotNumber: function(obj) {
        return !ns.util.type.isNumber(obj);
      },
      isNotObject: function(obj) {
        return !ns.util.type.isObject(obj);
      },
      isNotString: function(obj) {
        return !ns.util.type.isString(obj);
      },
      isDefined: function(obj) {
        return !ns.util.type.isUndefined(obj);
      }
    },
    instance: {
      isInstanceOf: function(obj, proto) {
        if (typeof proto !== 'function') {
          return false;
        }
        return obj instanceof proto;
      },
      isNotInstanceOf: function(obj, proto) {
        return !ns.util.instance.isInstanceOf(obj, proto);
      }
    }
  };

  ns.Test = (function() {
    var fn, name, _fn, _fn1, _ref, _ref1,
      _this = this;

    Test.LOGIC_MODE_AND = 'and';

    Test.LOGIC_MODE_OR = 'or';

    function Test(subject) {
      if (!(this instanceof Test)) {
        throw new Error('Bad construction, missing `new`');
      }
      this._subject = subject;
      this._logicMode = Test.LOGIC_MODE_AND;
      this._results = [];
    }

    Test.prototype.getSubject = function() {
      return this._subject;
    };

    Test.prototype.setLogicMode = function(logicMode) {
      if (this._results.length > 0) {
        throw new Error('Logic mode cannot be changed once assertions have been made');
      }
      if (logicMode !== Test.LOGIC_MODE_AND && logicMode !== Test.LOGIC_MODE_OR) {
        throw new Error('Invalid logic mode');
      }
      return this._logicMode = logicMode;
    };

    Test.prototype.getLogicMode = function() {
      return this._logicMode;
    };

    Test.prototype.assert = function() {
      var args, fn, pass, result;
      fn = arguments[0], args = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
      if (typeof fn !== 'function') {
        throw new Error('Invalid fn argument, function expected');
      }
      args.unshift(this.getSubject());
      result = fn.apply(this, args);
      pass = typeof result === 'boolean' ? result : false;
      this._results.push(pass);
      return pass;
    };

    _ref = ns.util.type;
    _fn = function(name) {
      return Test.prototype[name] = function() {
        return this.assert(ns.util.type[name]);
      };
    };
    for (name in _ref) {
      if (!__hasProp.call(_ref, name)) continue;
      fn = _ref[name];
      _fn(name);
    }

    _ref1 = ns.util.instance;
    _fn1 = function(name) {
      return Test.prototype[name] = function(proto) {
        return this.assert(ns.util.instance[name], proto);
      };
    };
    for (name in _ref1) {
      if (!__hasProp.call(_ref1, name)) continue;
      fn = _ref1[name];
      _fn1(name);
    }

    Test.prototype.passes = function() {
      if (this._results.length === 0) {
        return true;
      } else if (this.getLogicMode() === Test.LOGIC_MODE_AND) {
        return __indexOf.call(this._results, false) < 0;
      } else {
        return __indexOf.call(this._results, true) >= 0;
      }
    };

    return Test;

  }).call(this);

  ns.TestChain = (function(_super) {

    __extends(TestChain, _super);

    function TestChain(subject) {
      TestChain.__super__.constructor.call(this, subject);
      this.otherwise = this.and = this.or = this;
    }

    TestChain.prototype.all = function() {
      this.setLogicMode(ns.Test.LOGIC_MODE_AND);
      return this;
    };

    TestChain.prototype.either = function() {
      this.setLogicMode(ns.Test.LOGIC_MODE_OR);
      return this;
    };

    TestChain.prototype.assert = function() {
      TestChain.__super__.assert.apply(this, arguments);
      return this;
    };

    TestChain.prototype.error = function(object) {
      if (!(object instanceof Error) && typeof object !== 'string') {
        throw new Error('Invalid object argument, Error or string expected');
      }
      if (!this.passes()) {
        if (typeof object === 'string') {
          throw new Error(object);
        } else {
          throw object;
        }
      }
      return this;
    };

    return TestChain;

  })(ns.Test);

  ns.pledge = function(subject) {
    if (this instanceof ns.pledge) {
      throw new Error('Bad method call, unexpected `new`');
    }
    return new ns.TestChain(subject);
  };

  if (!(typeof module !== "undefined" && module !== null) && typeof window !== 'undefined') {
    window.pledge = ns.pledge;
    window.pledge.util = ns.util;
  } else {
    module.exports = ns;
  }

}).call(this);