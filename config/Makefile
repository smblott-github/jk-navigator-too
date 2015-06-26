# Requires GNU make.

# It can be easier to write JSON by building the relevant objects in
# Javascript/CoffeeScript then writing them out.  This Makefile helps to
# automate that process.  It also uploads the resulting files to a web server.

# Set target to an rsync-accessible target directory.
target ?= desktop:/home/www/smblott.org/jkn2

js = $(wildcard */*.js)
cs = $(wildcard */*.coffee)

install: $(js:.js=.txt) $(cs:.coffee=.txt)
	rsync $? $(target)

auto:
	@$(MAKE) --no-print-directory install
	# For "entr", see http://entrproject.org/.
	@ls $(cs) $(js) | entr $(MAKE) --no-print-directory auto-install

auto-install:
	@date
	@$(MAKE) --no-print-directory install

%.txt: %.coffee ../common.js
	coffee $< > $@

%.txt: %.js ../common.js
	node $< > $@

%.js: %.coffee
	coffee -c $<

.PHONY: install auto auto-install
