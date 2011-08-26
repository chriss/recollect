INSTALL_DIR=/var/www/recollect
SOURCE_FILES=root/*
LIB=lib
TEMPLATE_DIR=template
PRIVATE=../private
SQL=etc/sql/*
EXEC=bin/* $(PRIVATE)/bin/recollect-*

RECOLLECT_CSS=root/css/style.css
RECOLLECT_SASS=root/css/style.sass

CRONJOB=$(PRIVATE)/etc/cron.d/recollect
PSGI=etc/production.psgi

TESTS=$(wildcard t/*.t)
WIKITESTS=$(wildcard t/wikitests/*.t)
MAKE_TIME_FILES=$(BUILT_JS) $(shell find root/images root/css)

JAVASCRIPT=\
	root/javascript/compiled/recollect.js \
	root/javascript/compiled/recollect-wizard.js \
	root/javascript/compiled/recollect-radmin.js \

JAVASCRIPT_GZ=\
	root/javascript/compiled/recollect.jgz \
	root/javascript/compiled/recollect-wizard.jgz \
	root/javascript/compiled/recollect-radmin.jgz \

all: javascript $(RECOLLECT_CSS) root/make-time

javascript: $(JAVASCRIPT)

clean:
	rm -f  $(JEMPLATE) $(JAVASCRIPT) $(JAVASCRIPT_GZ)

.SUFFIXES: .js -mini.js .jgz

root/make-time: $(MAKE_TIME_FILES)
	date '+%s' > $@

root/javascript/compiled/recollect.js: $(shell bin/jsmake --parts recollect)
	bin/jsmake recollect

root/javascript/compiled/recollect-wizard.js: $(shell bin/jsmake --parts recollect-wizard)
	bin/jsmake recollect-wizard

root/javascript/compiled/recollect-radmin.js: $(shell bin/jsmake --parts recollect-radmin)
	bin/jsmake recollect-radmin

$(RECOLLECT_CSS): $(RECOLLECT_SASS) Makefile root/css/*.sass
	/var/lib/gems/1.8/bin/sass -t compressed $< $@

$(INSTALL_DIR)/%:
	mkdir $(INSTALL_DIR)
	mkdir $(INSTALL_DIR)/root
	mkdir $(INSTALL_DIR)/bin
	mkdir $(INSTALL_DIR)/etc
	mkdir $(INSTALL_DIR)/run
	chown -R recollect:www-data $(INSTALL_DIR)


install: all $(INSTALL_DIR)/* $(SOURCE_FILES) $(LIB) \
	$(TEMPLATES) $(EXEC) $(TEMPLATE_DIR) $(CRONJOB) $(PSGI) $(SQL)
	if [ ! -d $(INSTALL_DIR)/root/reports ]; then mkdir $(INSTALL_DIR)/root/reports; fi
	if [ ! -d $(INSTALL_DIR)/backup ]; then mkdir $(INSTALL_DIR)/backup; fi
	chown -R recollect:www-data $(INSTALL_DIR)/backup/
	if [ ! -d $(INSTALL_DIR)/etc/sql ]; then mkdir -p $(INSTALL_DIR)/etc/sql; fi
	if [ ! -f /var/log/recollect-server.log ]; then touch /var/log/recollect-server.log; chown recollect:www-data /var/log/recollect-server.log; fi
	rm -rf $(INSTALL_DIR)/root/css $(INSTALL_DIR)/root/images $(INSTALL_DIR)/root/javascript
	cp -R $(SOURCE_FILES) $(INSTALL_DIR)/root
	chown -R recollect:www-data $(INSTALL_DIR)/root
	cp -R $(LIB) $(TEMPLATE_DIR) $(INSTALL_DIR)
	cp -R $(SQL) $(INSTALL_DIR)/etc/sql
	cp $(PSGI) $(INSTALL_DIR)
	cp $(EXEC) $(INSTALL_DIR)/bin
	cp -f $(CRONJOB) /etc/cron.d/
	touch /var/www/recollect/run/send-reminders.quit
	cp -R etc/service $(INSTALL_DIR)/etc/service
	if [ ! -d /etc/service/recollect ]; then \
	    update-service --add $(INSTALL_DIR)/etc/service/recollect recollect; \
	fi
	sudo -u recollect $(INSTALL_DIR)/bin/recollect-db update
	svc -h /etc/service/recollect
	cp -f etc/nginx/sites-available/recollect.net /etc/nginx/sites-available
	ln -sf /etc/nginx/sites-available/recollect.net /etc/nginx/sites-enabled/recollect.net
	/etc/init.d/nginx reload
	sudo -u recollect $(INSTALL_DIR)/bin/generate-sitemap.pl

install-templates: $(TEMPLATES)
	cp -R $(TEMPLATE_DIR)/* $(INSTALL_DIR)/template

test: $(TESTS)
	prove -Ilib $(TESTS)

wikitest: $(WIKITESTS)
	prove $(WIKITESTS)
	
