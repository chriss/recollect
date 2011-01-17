INSTALL_DIR=/var/www/recollect
SOURCE_FILES=static/*
LIB=lib
TEMPLATE_DIR=template
EXEC=bin/*
MINIFY=perl -MJavaScript::Minifier::XS -0777 -e 'print JavaScript::Minifier::XS::minify(scalar <>);'
#MINIFY=cat

JS_DIR=static/javascript

JEMPLATE=$(JS_DIR)/Jemplate.js
JEMPLATES=$(wildcard $(JS_DIR)/template/*.tt2)

RECOLLECT=$(JS_DIR)/recollect.js
RECOLLECT_GZ=$(JS_DIR)/recollect.js.gz
RECOLLECT_MINIFIED=$(JS_DIR)/recollect-mini.js
RECOLLECT_FILES=\
	 $(JS_DIR)/libs/jquery-1.4.2.min.js \
	 $(JS_DIR)/libs/jquery-ui-1.8.6.custom.min.js \
	 $(JS_DIR)/libs/jquery-json-1.3.js \
	 $(JS_DIR)/libs/jquery-maskedinput-1.2.2.min.js \
	 $(JS_DIR)/libs/jquery.validate.js \
	 $(JS_DIR)/recollect/reminders.js \
	 $(JEMPLATE) \

RECOLLECT_MAP=$(JS_DIR)/recollect-map.js
RECOLLECT_MAP_GZ=$(JS_DIR)/recollect-map.js.gz
RECOLLECT_MAP_MINIFIED=$(JS_DIR)/recollect-map-mini.js
RECOLLECT_MAP_FILES=\
	 $(JS_DIR)/libs/egeoxml.js \
	 $(JS_DIR)/libs/epoly.js \
	 $(JS_DIR)/recollect/map.js \

RECOLLECT_MOBILE=$(JS_DIR)/recollect-mobile.js
RECOLLECT_MOBILE_GZ=$(JS_DIR)/recollect-mobile.js.gz
RECOLLECT_MOBILE_MINIFIED=$(JS_DIR)/recollect-mobile-mini.js
RECOLLECT_MOBILE_FILES=\
	 $(JS_DIR)/libs/jquery-1.4.2.min.js \
	 $(JS_DIR)/libs/jquery-ui-1.8.6.custom.min.js \
	 $(JS_DIR)/libs/jquery-json-1.3.js \
	 $(JS_DIR)/libs/gears_init.js \
	 $(JS_DIR)/recollect/cal.js \
	 $(JS_DIR)/recollect/map.js \
	 $(JS_DIR)/recollect/reminders.js \

CRONJOB=etc/cron.d/recollect
PSGI=production.psgi

TESTS=$(wildcard t/*.t)
WIKITESTS=$(wildcard t/wikitests/*.t)

BUILT_JS=\
    $(RECOLLECT) $(RECOLLECT_GZ) $(RECOLLECT_MINIFIED) \
    $(RECOLLECT_MOBILE) $(RECOLLECT_MOBILE_GZ) $(RECOLLECT_MOBILE_MINIFIED) \
    $(RECOLLECT_MAP) $(RECOLLECT_MAP_GZ) $(RECOLLECT_MAP_MINIFIED) \

all: javascript

javascript: $(BUILT_JS)

clean:
	rm -f  $(JEMPLATE) $(BUILT_JS)

.SUFFIXES: .js -mini.js .js.gz

.js-mini.js:
	$(MINIFY) $< > $@

$(JEMPLATE): $(JEMPLATES)
	jemplate --runtime=jquery > $@
	echo ';' >> $@
	jemplate --compile $(JEMPLATES) >> $@
	echo ';' >> $@

$(RECOLLECT): $(RECOLLECT_FILES) Makefile
	rm -f $@;
	for js in $(RECOLLECT_FILES); do \
	    (echo "// BEGIN $$js"; cat $$js | perl -pe 's/\r//g') >> $@; \
	done

$(RECOLLECT_MOBILE): $(RECOLLECT_MOBILE_FILES) Makefile
	rm -f $@;
	for js in $(RECOLLECT_MOBILE_FILES); do \
	    (echo "// BEGIN $$js"; cat $$js | perl -pe 's/\r//g') >> $@; \
	done

$(RECOLLECT_MAP): $(RECOLLECT_MAP_FILES) Makefile
	rm -f $@;
	for js in $(RECOLLECT_MAP_FILES); do \
	    (echo "// BEGIN $$js"; cat $$js | perl -pe 's/\r//g') >> $@; \
	done

-mini.js.js.gz:
	gzip -c $< > $@

$(INSTALL_DIR)/%:
	mkdir $(INSTALL_DIR)
	mkdir $(INSTALL_DIR)/root
	mkdir $(INSTALL_DIR)/bin
	mkdir $(INSTALL_DIR)/etc
	chown -R recollect:www-data $(INSTALL_DIR)


install: javascript $(INSTALL_DIR)/* $(SOURCE_FILES) $(LIB) \
	$(TEMPLATES) $(EXEC) $(TEMPLATE_DIR) $(CRONJOB) $(PSGI)
	rm -rf $(INSTALL_DIR)/root/css
	rm -rf $(INSTALL_DIR)/root/images
	rm -rf $(INSTALL_DIR)/root/javascript
	if [ ! -d $(INSTALL_DIR)/root/reports ]; then mkdir $(INSTALL_DIR)/root/reports; fi
	if [ ! -d $(INSTALL_DIR)/backup ]; then mkdir $(INSTALL_DIR)/backup; fi
	if [ ! -f /var/log/recollect-server.log ]; then touch /var/log/recollect-server.log; chown recollect:www-data /var/log/recollect-server.log; fi
	cp -R $(SOURCE_FILES) $(INSTALL_DIR)/root
	cp -R $(LIB) $(TEMPLATE_DIR) $(INSTALL_DIR)
	rm -f $(INSTALL_DIR)/root/*.html
	cp $(PSGI) $(INSTALL_DIR)
	cp $(EXEC) $(INSTALL_DIR)/bin
	cp -f etc/cron.d/recollect /etc/cron.d/recollect
	cp -f etc/areas.yaml $(INSTALL_DIR)/etc/areas.yaml
	svc -d /etc/service/recollect
	rm -rf $(INSTALL_DIR)/etc/service
	cp -R etc/service $(INSTALL_DIR)/etc/service
	if [ ! -d /etc/service/recollect ]; then \
	    update-service --add $(INSTALL_DIR)/etc/service/recollect recollect; \
	fi
	svc -u /etc/service/recollect
	cp -f etc/nginx/sites-available/recollect.net /etc/nginx/sites-available
	ln -sf /etc/nginx/sites-available/recollect.net /etc/nginx/sites-enabled/recollect.net
	chown -R recollect:www-data $(INSTALL_DIR)/root
	chown -R recollect:www-data $(INSTALL_DIR)/backup/
	/etc/init.d/nginx reload

test: $(TESTS)
	prove -Ilib $(TESTS)

wikitest: $(WIKITESTS)
	prove $(WIKITESTS)
	
