
build:
	coffee -c *.coffee ./config/*/*.coffee ./options/*.coffee

auto:
	coffee -w -c .

key = $(HOME)/local/sbenv/ssh/jk-navigator-too.pem

# Intended primarily for developer.
pack:
	$(MAKE) build && \
	   cd .. && \
	   google-chrome --pack-extension=jk-navigator-too --pack-extension-key=$(key) && \
	   mv -v jk-navigator-too.crx $(HOME)/storage/google-drive/Extensions

.PHONY: build auto pack

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
	mv -v jk-navigator-too.zip ~/storage/google-drive/Extensions

