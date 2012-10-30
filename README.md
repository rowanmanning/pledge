
# Pledge #

Pledge is a pretty little argument validation library for your
browser and server. It has a simple and expressive syntax which
makes validating variables and arguments an enjoyable task!

[![Build Status][travis-status]][travis]


## Installation ##

**Browser (Bower)**  
You can use Pledge in your browser project by installing it
through [Bower][bower] with `bower install pledge` (or by
adding it as a project dependency).

**Browser (no package manager)**  
To use Pledge without a package manager in-browser, copy/link
to `dist/pledge.js` or `dist/pledge.min.js` and start using.

Pledge will work fine if you use a dependency manager like [Browserify][browserify].

**Server (Node.js):**  
Just install with `npm install pledge` or add it to your
`package.json`.


## Usage ##

Pledge exposes a function which can be used to validate
arguments and optionally error if the validation fails. It's
useful for testing input sanity.

You can use pledge with Node.js (JavaScript or CoffeeScript):

```js
var pledge = require('pledge').pledge;
```

```coffeescript
{pledge} = require 'pledge'
```

or in-browser the `pledge` function is exposed as
`window.pledge`.

### Pledge Function ###

The `pledge` function can be called with any argument, the
argument being the subject of the test:

```js
pledge('foo')
pledge(123)
pledge([1, 2, 3])
```

This function returns a `Test` object.

### Assertions ###

The test object has many assertion methods which are chainable,
use these to assert that the test subject fits within certain
parameters:

```js
pledge([]).isArray()
pledge(true).isBoolean()
pledge(Date).isFunction()
pledge(null).isNull()
pledge(123).isNumber()
pledge({}).isObject()
pledge('foo').isString()
pledge(undefined).isUndefined()
pledge(new Date()).isInstanceOf(Date)
```

Pledge also provides negative assertions to match the above:

```js
pledge(123).isNotArray()
pledge('foo').isNotBoolean()
pledge({}).isNotFunction()
pledge([]).isNotNull()
pledge(Date).isNotNumber()
pledge(true).isNotObject()
pledge(undefined).isNotString()
pledge(new Date()).isDefined()
pledge(null).isNotInstanceOf(Date)
```

### Results ###

You can handle the results of your assertions in two different
ways. Firstly, the unchainable `passes` method:

```js
pledge('foo').isString().passes() // true
pledge(123).isString().passes() // false
```

Secondly, the `error` method can be used to throw when the test
does not pass:

```js
pledge('foo').isString().error('Not a string!') // doesn't throw
pledge(123).isString().error('Not a string!') // throws a new `Error` with the passed in string as a message
pledge(123).isString().error(new Error('Oops')) // throws the error passed into the method
```

### Logic Modes ###

For multiple assertions, pledge supports `and` and `or` logic
modes. These can be set with the methods `all` or `either`,
called before any assertions.

```js
pledge('foo').all().isDefined().isString().passes() // true
pledge('foo').all().isNumber().isString().passes() // false
pledge('foo').either().isNumber().isString().passes() // true
pledge('foo').either().isArray().isObject().passes() // false
```

It's worth noting that `all` is the default logic mode, so
there's not often a need to add this.

### Sugar ###

Pledge provides a little (optional) sugar with a couple of
properties that just alias the pledge object, `and`, `or` and
`otherwise`. You can use them like this:

```js
pledge('foo').isString().otherwise.error('Oops')
pledge('foo').isString().and.isDefined()
pledge('foo').either().isNumber().or.isString()
```

### Example ###

Here's an example of Pledge in use!

```js
function createPerson (name, age) {
    pledge(name).isString().otherwise.error('Invalid name, string expected');
    pledge(age).either().isNumber().or.isNull().otherwise.error('Invalid age, number or null expected');
    return {name: name, age: age};
}
```


## Development ##

In order to develop Pledge, you'll need to install the following
npm modules globally like so:

    npm install -g coffee-script
    npm install -g jake

And then install development dependencies locally with:

    npm install

Once you have these dependencies, you will be able to run the
following commands:

`jake build`: Build JavaScript from the CoffeeScript source.

`jake dist`: Build browser JavaScript from the built JavaScript.

`jake integration`: Run all integration tests.

`jake lint`: Lint all CoffeeScript source with CoffeeLint.

`jake test`: Run all unit tests.


## License ##

Dual licensed under the [MIT][mit] or [GPL Version 2][gpl]
licenses.


[bower]: http://twitter.github.com/bower/
[browserify]: http://github.com/substack/node-browserify
[gpl]: http://opensource.org/licenses/gpl-2.0.php
[mit]: http://opensource.org/licenses/mit-license.php
[travis]: http://secure.travis-ci.org/rowanmanning/pledge
[travis-status]: https://secure.travis-ci.org/rowanmanning/pledge.png?branch=0.2.x