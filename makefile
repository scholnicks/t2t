# Makefile for t2t installation
#
# See http://www.scholnick.net/t2t for details

# Edit as necessary

PERL      = $(shell which perl)
PERLLIB   = $(shell $(PERL) -V:sitelib | cut -d"'" -f2)
BINDIR    = $(shell $(PERL) -V:installsitebin | cut -d"'" -f2)
MANDIR    = $(shell $(PERL) -V:installman1dir | cut -d"'" -f2)

install: main modules doc rc

test::
	@echo $(PERLLIB)
	@echo $(BINDIR)
	@echo $(MANDIR)
	@echo $(USER)
	@echo $(GROUP)

main::
	cp t2t.pl $(BINDIR)/t2t
	chmod 755 $(BINDIR)/t2t

modules::
	cp -R T2t $(PERLLIB)
	chmod 755 $(PERLLIB)/T2t
	chmod a+r $(PERLLIB)/T2t/*.pm
	
doc::
	install -m 644 t2t.1 $(MANDIR)

rc::
	cp t2t.rc $(HOME)/.t2trc
	chmod a+r $(HOME)/.t2trc
	chown $(USER):$(GROUP) $(HOME)/.t2trc

