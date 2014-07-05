# promitto [![Build Status](https://secure.travis-ci.org/h2non/promitto.png?branch=master)][travis] [![NPM version](https://badge.fury.io/js/promitto.png)][npm]

**promitto** is a tiny and funny **Promise/Deferred library for JavaScript environments** which provides an elegant, standard simple [API](#api)

It's compatible with the [Promise/A+ spec](http://promises-aplus.github.io/promises-spec/)
and it provides useful features for asynchronous promise-based pattern programming

promitto is written in [Wisp][wisp], a Clojure-like language that transpiles into plain JavaScript.
It exploits functional programming style using common patterns such as lambda lifting, pure functions, higher-order functions, functional composition and more

## Installation

#### Node.js

```bash
$ npm install promitto --save
```

#### Browser

Via Bower package manager
```bash
$ bower install promitto --save
```

Or loading the script remotely (just for testing or development)
```html
<script src="//rawgithub.com/h2non/promitto/master/promitto.js"></script>
```

### Environments

It works properly in any ES5 compliant engine

- Node.js
- Chrome >= 5
- Firefox >= 3
- Safari >= 5
- Opera >= 12
- IE >= 9

## Basic usage

```js
var promitto = require('promitto')
```

Using [Deferred](#promittodefer) pattern
```js
var p = require('promitto')

function doAsyncJob() {
  var defer = p.defer()
  get('http://www.google.com', function (err, res) {
    if (err) defer.reject(err)
    else defer.resolve(res)
  })
  return defer.promise
}

doAsyncJob().then(function (data) {
  console.log(data)
}).throw(function (reason) {
  console.error('Error:', reason)
})
```

Using the [Promise](#promittopromisetask) pattern (Promise/A+ / ES6 compatible)
```js
var Promise = require('promitto').Promise

var promise = Promise(function doJob(resolve, reject, notify) {
  get('http://www.google.com', function (err, res) {
    if (err) reject(err)
    else resolve(res)
  })
})

promise.then(function (data) {
  console.log(data)
}).throw(function (reason) {
  console.error('Error:', reason)
})
```

## API

#### promitto(callback)

Create a new promitto promise passing the task function

```js
promitto(function readPackage(resolve, reject, notify) {
  fs.readFile('./package.json', function (err, data) {
    if (err) reject(err)
    else resolve(JSON.parse(data))
  })
}).then(function (pkg) {
  console.log('Name:', pkg.name)
}).throw(function (reason) {
  console.error('Error:', reason)
})
```

#### promitto.defer()

Creates a Deferred object

#### promitto.Promise(task)

Creates a new [Promise](#promise) compatible with the ES6 promise interface

#### promitto.when(value)

Wrap an object that might be a value or a 3rd party promise

This is useful when you are dealing with an object that might or might not be a promise, or if the promise comes from a source that can't be trusted

#### promitto.reject(reason)

Creates a promise that is resolved as rejected with the specified reason

#### promitto.resolve(reason)

Creates a promise that is resolved with the specified reason

#### promitto.all([promises])

Combines multiple promises into a single promise that is resolved when all of the input promises are resolved

Returns a single promise that will be resolved with an array/hash of values, each value corresponding to the promise at the same index/key in the promises array/hash

#### promitto.isPromise(value)

Return if a given value is a compatible promise

### Promise

#### then(onResolve, onReject, onNotify)

#### throw(callback)

#### finally(callback)

#### notify(callback)

## Contributing

Wanna help? Cool! It will be really apreciated :)

You must add new test cases for any new feature or refactor you do,
always following the same design/code patterns that already exist

Tests specs are completely written in Wisp language.
Take a look to the language [documentation][wisp] if you are new with it.
You should follow the Wisp language coding conventions

### Development

Only [node.js](http://nodejs.org) is required for development

Clone/fork this repository
```
$ git clone https://github.com/h2non/promitto.git && cd promitto
```

Install package dependencies
```
$ npm install
```

Compile code
```
$ make compile
```

Run tests
```
$ make test
```

Browser sources bundle generation
```
$ make browser
```

Release a new version
```
$ make release
```

## License

[MIT](http://opensource.org/licenses/MIT) - Tomas Aparicio

[wisp]: https://github.com/Gozala/wisp
[travis]: http://travis-ci.org/h2non/promitto
[npm]: http://npmjs.org/package/promitto
