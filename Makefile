# dmenu - dynamic menu
# See LICENSE file for copyright and license details.

include config.mk

SRC = drw.c dmenu.c stest.c util.c
OBJ = $(SRC:.c=.o)

all: options dmenu stest

options:
	@echo dmenu build options:
	@echo "CFLAGS   = $(CFLAGS)"
	@echo "LDFLAGS  = $(LDFLAGS)"
	@echo "CC       = $(CC)"

.c.o:
	$(CC) -c $(CFLAGS) $<

config.h:
	cp config.def.h $@

$(OBJ): arg.h config.h config.mk drw.h

dmenu: dmenu.o drw.o util.o
	$(CC) -o $@ dmenu.o drw.o util.o $(LDFLAGS)

stest: stest.o
	$(CC) -o $@ stest.o $(LDFLAGS)

clean:
	rm -f dmenu stest $(OBJ) dmenu-$(VERSION).tar.gz

dist: clean
	mkdir -p dmenu-$(VERSION)
	cp LICENSE Makefile README arg.h config.def.h config.mk dmenu.1\
		drw.h util.h dmenu_path stest.1\
		scripts/dmenu_run_i\
		scripts/passmenu\
		scripts/projectmenu\
		scripts/recent_list\
		scripts/quickeditmenu\
		scripts/quickrunmenu\
		scripts/uttmenu\
		scripts/xdgopenmenu\
		$(SRC) dmenu-$(VERSION)
	tar -cf dmenu-$(VERSION).tar dmenu-$(VERSION)
	gzip dmenu-$(VERSION).tar
	rm -rf dmenu-$(VERSION)

install: all
	mkdir -p $(DESTDIR)$(PREFIX)/bin
	cp -f dmenu dmenu_path stest\
		scripts/dmenu_run_i\
		scripts/passmenu\
		scripts/projectmenu\
		scripts/recent_list_cache\
		scripts/quickeditmenu\
		scripts/quickrunmenu\
		scripts/uttmenu\
		scripts/xdgopenmenu\
		$(DESTDIR)$(PREFIX)/bin
	chmod 755 $(DESTDIR)$(PREFIX)/bin/stest
	chmod 755 $(DESTDIR)$(PREFIX)/bin/dmenu
	chmod 755 $(DESTDIR)$(PREFIX)/bin/dmenu_path
	chmod 755 $(DESTDIR)$(PREFIX)/bin/dmenu_run_i
	chmod 755 $(DESTDIR)$(PREFIX)/bin/passmenu
	chmod 755 $(DESTDIR)$(PREFIX)/bin/projectmenu
	chmod 755 $(DESTDIR)$(PREFIX)/bin/recent_list_cache
	chmod 755 $(DESTDIR)$(PREFIX)/bin/quickeditmenu
	chmod 755 $(DESTDIR)$(PREFIX)/bin/quickrunmenu
	chmod 755 $(DESTDIR)$(PREFIX)/bin/uttmenu
	chmod 755 $(DESTDIR)$(PREFIX)/bin/xdgopenmenu
	mkdir -p $(DESTDIR)$(MANPREFIX)/man1
	sed "s/VERSION/$(VERSION)/g" < dmenu.1 > $(DESTDIR)$(MANPREFIX)/man1/dmenu.1
	sed "s/VERSION/$(VERSION)/g" < stest.1 > $(DESTDIR)$(MANPREFIX)/man1/stest.1
	chmod 644 $(DESTDIR)$(MANPREFIX)/man1/dmenu.1
	chmod 644 $(DESTDIR)$(MANPREFIX)/man1/stest.1

uninstall:
	rm -f $(DESTDIR)$(PREFIX)/bin/dmenu\
		$(DESTDIR)$(PREFIX)/bin/dmenu_path\
		$(DESTDIR)$(PREFIX)/bin/dmenu_run_i\
		$(DESTDIR)$(PREFIX)/bin/stest\
		$(DESTDIR)$(PREFIX)/bin/passmenu\
		$(DESTDIR)$(PREFIX)/bin/projectmenu\
		$(DESTDIR)$(PREFIX)/bin/recent_list_cache\
		$(DESTDIR)$(PREFIX)/bin/quickeditmenu\
		$(DESTDIR)$(PREFIX)/bin/quickrunmenu\
		$(DESTDIR)$(PREFIX)/bin/uttmenu\
		$(DESTDIR)$(PREFIX)/bin/xdgopenmenu\
		$(DESTDIR)$(MANPREFIX)/man1/dmenu.1\
		$(DESTDIR)$(MANPREFIX)/man1/stest.1

.PHONY: all options clean dist install uninstall
