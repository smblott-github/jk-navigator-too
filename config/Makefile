
install: jk-navigator-too.txt
	install -v -m 0444 $< /home/www/smblott.org/static
	install -v -m 0444 $< /home/www/smblott.org

%.txt: %.coffee
	coffee $< > $@

