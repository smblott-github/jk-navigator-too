#
# Requirements:
# - GNU make
# - nodejs
# - coffeescript (sudo npm install -g coffee-script)
# - (optional) entr (http://entrproject.org/).
# - rsync

# Instead of writing JSON by hand, we write a Javascript or CoffeeScript
# program to build the JSON.  There are examples in the */*.coffee files.

# Set target to an rsync-accessible target directory.
# For example:
#
#   make target=my-server:public_html/jkn2 install
#
# Targets:
#
#   install: build the config files and install them
#
#   build: just build the config files
#
#   auto: (requires entr) install, then run install again whenever one of the
#         source files changes

target ?= desktop:/home/www/smblott.org/jkn2

js = $(wildcard */*.js)
cs = $(wildcard */*.coffee)

install:
	@$(MAKE) --no-print-directory .install

.install: $(js:.js=.txt) $(cs:.coffee=.txt)
	rsync --relative --verbose $? $(target)
	@touch .install

build: $(js:.js=.txt) $(cs:.coffee=.txt)

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

clean:
	rm -f .install
	find . -type f -name '*.txt' -delete

.PHONY: install auto auto-install clean
