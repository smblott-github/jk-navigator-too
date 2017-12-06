
src = $(shell find . -name '*.coffee')

build:
	coffee -c $(src)

auto:
	coffee -w -c .

# For Chrome Store.
chrome-store:
	$(MAKE) build
	zip -r jk-navigator-too.zip . -x \
	   '*'.coffee \
	   icons/icon-512.png \
	   config/'*' \
	   Makefile \
	   .git/'*' \
	   LICENSE \
	   '*'.md \
	   .gitignore
	mv -v jk-navigator-too.zip ~/smblott@gmail.com/extensions/

.PHONY: build auto chrome-store

