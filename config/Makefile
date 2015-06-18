
install: jk-navigator-too.txt
	rsync $< desktop:/home/www/smblott.org/static
	rsync $< desktop:/home/www/smblott.org

%.txt: %.coffee
	coffee $< > $@

