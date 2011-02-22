INSTALL_DIR=/var/www/recollect
SOURCE_FILES=root/*
LIB=lib
TEMPLATE_DIR=template
PRIVATE=../private
EXEC=bin/* $(PRIVATE)/bin/recollect-*
MINIFY=perl -MJavaScript::Minifier::XS -0777 -e 'print JavaScript::Minifier::XS::minify(scalar <>);'
#MINIFY=cat

JS_DIR=root/javascript

JEMPLATE=$(JS_DIR)/Jemplate.js
JEMPLATES=$(wildcard $(JS_DIR)/template/*.tt2)

RECOLLECT=$(JS_DIR)/compiled-recollect.js
RECOLLECT_GZ=$(JS_DIR)/compiled-recollect.js.gz
RECOLLECT_MINIFIED=$(JS_DIR)/compiled-recollect-mini.js
RECOLLECT_FILES=\
	 $(JS_DIR)/libs/jquery-1.4.2.min.js \
	 $(JS_DIR)/libs/jquery-ui-1.8.6.custom.min.js \
	 $(JS_DIR)/libs/jquery-maskedinput-1.2.2.min.js \
	 $(JS_DIR)/libs/jquery.validate.js \
	 $(JS_DIR)/libs/geoxml3.js \
	 $(JS_DIR)/libs/jquery.cookie.js \
	 $(JS_DIR)/libs/google.polygon.js \
	 $(JS_DIR)/libs/jquery.scrollTo-1.4.2-min.js \
	 $(JS_DIR)/libs/json2.js \
	 $(JS_DIR)/libs/history.adapter.jquery.js \
	 $(JS_DIR)/libs/history.js \
	 $(JS_DIR)/libs/history.html4.js \
	 $(JS_DIR)/recollect/wizard.js \
	 $(JEMPLATE) \

CRONJOB=$(PRIVATE)/etc/cron.d/recollect
PSGI=etc/production.psgi

TESTS=$(wildcard t/*.t)
WIKITESTS=$(wildcard t/wikitests/*.t)
MAKE_TIME_FILES=$(BUILT_JS) $(shell find root/images root/css)

BUILT_JS=\
    $(RECOLLECT) $(RECOLLECT_GZ) $(RECOLLECT_MINIFIED) \

all: javascript root/make-time

javascript: $(BUILT_JS)

clean:
	rm -f  $(JEMPLATE) $(BUILT_JS)

.SUFFIXES: .js -mini.js .js.gz

root/make-time: $(MAKE_TIME_FILES)
	date '+%s' > $@

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
	    (echo "// BEGIN $$js"; cat $$js; echo ';' | perl -pe 's/\r//g') >> $@; \
	done

-mini.js.js.gz:
	gzip -c $< > $@

$(INSTALL_DIR)/%:
	mkdir $(INSTALL_DIR)
	mkdir $(INSTALL_DIR)/root
	mkdir $(INSTALL_DIR)/bin
	mkdir $(INSTALL_DIR)/etc
	mkdir $(INSTALL_DIR)/run
	chown -R recollect:www-data $(INSTALL_DIR)


install: all $(INSTALL_DIR)/* $(SOURCE_FILES) $(LIB) \
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
	cp -f $(CRONJOB) /etc/cron.d/
	cp -f etc/areas.yaml $(INSTALL_DIR)/etc/areas.yaml
	cp -R etc/service $(INSTALL_DIR)/etc/service
	if [ ! -d /etc/service/recollect ]; then \
	    update-service --add $(INSTALL_DIR)/etc/service/recollect recollect; \
	fi
	svc -h /etc/service/recollect
	cp -f etc/nginx/sites-available/recollect.net /etc/nginx/sites-available
	ln -sf /etc/nginx/sites-available/recollect.net /etc/nginx/sites-enabled/recollect.net
	chown -R recollect:www-data $(INSTALL_DIR)/root
	chown -R recollect:www-data $(INSTALL_DIR)/backup/
	/etc/init.d/nginx reload

test: $(TESTS)
	prove -Ilib $(TESTS)

wikitest: $(WIKITESTS)
	prove $(WIKITESTS)
	
