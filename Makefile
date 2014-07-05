BROWSERIFY = node ./node_modules/browserify/bin/cmd.js
WISP = ./node_modules/wisp/bin/wisp.js
WISP_MODULE = ./node_modules/wisp/
MOCHA = ./node_modules/.bin/mocha
UGLIFYJS = ./node_modules/.bin/uglifyjs
BANNER = "/*! promitto.js - v0.1 - MIT License - https://github.com/h2non/promitto */"

define release
	VERSION=`node -pe "require('./package.json').version"` && \
	NEXT_VERSION=`node -pe "require('semver').inc(\"$$VERSION\", '$(1)')"` && \
	node -e "\
		var j = require('./package.json');\
		j.version = \"$$NEXT_VERSION\";\
		var s = JSON.stringify(j, null, 2);\
		require('fs').writeFileSync('./package.json', s);" && \
	node -e "\
		var j = require('./bower.json');\
		j.version = \"$$NEXT_VERSION\";\
		var s = JSON.stringify(j, null, 2);\
		require('fs').writeFileSync('./bower.json', s);" && \
	git commit -am "release $$NEXT_VERSION" && \
	git tag "$$NEXT_VERSION" -m "Version $$NEXT_VERSION"
endef

define replace
	node -e "\
		var fs = require('fs'); \
		var os = require('os-shim'); \
		var str = fs.readFileSync('./promitto.js').toString(); \
		str = str.split(os.EOL).map(function (line) { \
		  return line.replace(/^void 0;/, '') \
		}).filter(function (line) { \
		  return line.length \
		}) \
		.join(os. EOL) \
		.replace(/(var _ns_ = \{\n((.*)\n(.*)\n\s+\}\;(\n)?))+/g, '') \
		.replace(/(\{(\s+)?\n(\s+)?\}\n)/g, ''); \
		fs.writeFileSync('./promitto.js', str)"
endef

default: all
all: test browser
browser: cleanbrowser test banner browserify replace uglify
test: compile mocha

mkdir:
	mkdir -p lib

compile: mkdir clean
	cat src/macros.wisp src/utils.wisp | $(WISP) --no-map > ./lib/utils.js
	cat src/macros.wisp src/promise.wisp | $(WISP) --no-map > ./lib/promise.js
	cat src/macros.wisp src/deferred.wisp | $(WISP) --no-map > ./lib/deferred.js
	cat src/macros.wisp src/collections.wisp | $(WISP) --no-map > ./lib/collections.js
	cat src/macros.wisp src/types.wisp | $(WISP) --no-map > ./lib/types.js
	cat src/macros.wisp src/promitto.wisp | $(WISP) --no-map > ./lib/promitto.js

banner:
	@echo $(BANNER) > promitto.js

browserify:
	$(BROWSERIFY) \
		--exports require \
		--standalone promitto \
		--entry ./lib/promitto.js >> ./promitto.js

replace:
	@$(call replace)

uglify:
	$(UGLIFYJS) promitto.js --mangle --preamble $(BANNER) > promitto.min.js

clean:
	rm -rf lib/*

cleanbrowser:
	rm -f *.js

mocha:
	$(MOCHA) --reporter spec --ui tdd --compilers wisp:$(WISP_MODULE)

loc:
	wc -l src/*

release:
	@$(call release, patch)

release-minor:
	@$(call release, minor)

publish: browser release
	git push --tags origin HEAD:master
	npm publish
