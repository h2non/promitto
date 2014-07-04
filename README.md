# promitto [![Build Status](https://secure.travis-ci.org/h2non/promitto.png?branch=master)][travis] [![NPM version](https://badge.fury.io/js/promitto.png)][npm]

**promitto** is a tiny and funny **promises and deferred library for JavaScript environments**

It's compatible with the [Promise/A+ spec](http://promises-aplus.github.io/promises-spec/)
and it provides useful features for dealing with asynchronous promise-based patterns

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

## Usage

```js
var p = require('promitto')

function doJob() {
  var defer = p.defer()

  asyncJob(function (err, data) {
    if (err) {
      defer.reject(err)      
    } else {
      defer.resolve(data)
    }
  })

  return defer.promise
}
```

## API

#### Promitto(callback)

#### Promitto.defer()

#### Promitto.Promise(callback)

#### Promitto.when(promise)

#### Promitto.reject(reason)

#### Promitto.resolve(reason)

#### Promitto.all([promises])

#### Promitto.isPromise(obj)

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
