
build:
	coffee -c foreground/*.coffee options/server.coffee

auto:
	coffee -w -c .

.PHONY: build auto pack-extension pack

# For Chrome Store.
pack:
	$(MAKE) build
	zip -r jk-navigator-too.zip chrome-extension \
	   -x '*'.coffee \
	   -x icons/icon-512.png

