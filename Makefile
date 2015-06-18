
build:
	coffee -c *.coffee ./config/*.coffee

auto:
	coffee -w -c .

.PHONY: build auto

# # For Chrome Store.
# pack:
# 	$(MAKE) build
# 	zip -r jk-navigator-too.zip chrome-extension \
# 	   -x '*'.coffee \
# 	   -x icons/icon-512.png

