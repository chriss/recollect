(function($) {

if (typeof(Recollect) == 'undefined') Recollect = {};

Recollect.Wizard  = function(opts) {
    $.extend(this, this._defaults, opts);
}

Recollect.Wizard .prototype = {
    dayNames: [ 'Sun','Mon','Tue','Wed','Thu','Fri','Sat' ],
    monthNames: [
        'Jan','Feb','Mar','Apr','May','Jun',
        'Jul','Aug','Sept','Oct','Nov','Dec'
    ],

    reminder: {},
    zone: {},

    start: function() {
        var self = this;
        self.findPage();
        var hash = location.hash;
        setInterval(function() {
            if (!self.inProgress && location.hash != hash) {
                self.inProgress = true; // reset to false after show()
                var old_hash = location.hash;
                self.findPage();
                hash = location.hash;
            }
        }, 500);
    },

    findPage: function() {
        var parts = [];
        if (location.hash.match(/^#!\/(.*)/)) parts = RegExp.$1.split('/');
        if (parts.length == 0) {
            this.showPage('address');
        }
        else {
            this.showPage.apply(this, parts);
        }
    },

    pages: {
        address: function() {
            var self = this;
            var opts = {
                height: 200,
                opacity: 0.8,
                page: 'wizardAddress'
            };
            self.show(opts, function() {
                $('#wizard .address')
                    .click(function() {
                        $(this).removeClass('initial').val('').unbind('click');
                    })
                    .keyup(function() {
                        var $node = $(this);
                        var request = { address: $node.val(), region: 'ca' };
                        var geocoder = new google.maps.Geocoder();
                        geocoder.geocode(request, function(results, status) {
                            if (status != google.maps.GeocoderStatus.OK) {
                                console.log('not ok');
                                return;
                            }
                            $node.autocomplete({
                                source: $.map(results, function(r) {
                                    return r.formatted_address;
                                })
                            });
                        });
                    });

                $('#wizard #search').click(function(){
                    $('#wizard form').submit();
                    return false;
                });

                $('#wizard form').submit(function(){
                    var request = {
                        address: $('#wizard .address').val(),
                        region: 'ca'
                    };

                    var geocoder = new google.maps.Geocoder();
                    geocoder.geocode(request, function(results, status) {
                        if (status == google.maps.GeocoderStatus.OK) {
                            results = self.restrictLocalities(results);
                        }

                        if (results.length == 1) {
                            var loc = results[0].geometry.location;
                            self.showZoneAt(loc.lat(), loc.lng());
                        }
                        else if (results.length == 0) {
                            $('#wizard .status').html(
                                Jemplate.process('error', {
                                    msg: "Found 0 Results"
                                })
                            );
                        }
                        else {
                            $('#wizard .status').html(
                                Jemplate.process('addresses', {
                                    results: results
                                })
                            );
                            $('#wizard .status a').click(function() {
                                var lat = $(this).attr('lat');
                                var lng = $(this).attr('lng');
                                $('#wizard .status').fadeOut(function() {
                                    self.showZoneAt(lat, lng);
                                });
                                return false;
                            });
                        }
                    });
                    return false;
                });
            });
        },

        zones: function(zone) {
            var self = this;

            self.getZone(zone, function(zone) {
                var opts = {
                    height: 500,
                    opacity: 1,
                    page: 'wizardZone',
                    feeds: self.feeds(zone)
                };
                $.extend(opts, zone);
                self.show(opts, function() {
                    self.showCalendar(zone);
                    self.showMap(zone);
                    $('#wizard #subscribe').click(function(){
                        self.setHash('subscribe', zone.name);
                        return false;
                    });
                });
            });
        },

        subscribe: function(zone, type) {
            var self = this;

            if (type) {
            }
            else {
                var opts = {
                    height: 300,
                    opacity: 1,
                    page: 'wizardSubscribe'
                };
                $.extend(opts, zone);
                self.show(opts, function() {
                    $('#wizard .next').click(function(){
                        self.setHash(
                            'subscribe', zone.name,
                            $('input[name=reminder-radio]:selected').val()
                        );
                        return false;
                    });
                });
            }
        }

        /*
        premium_sms: function() {
            focus: '.phone',
            back: function() { self.showPage('choose_method') },
            submit: function($cur) {
                self.showPage('loading');
                self.addReminder({
                    offset: $cur.find('.customOffset').val(),
                    email: $cur.find('.email').val(),
                    target: 'sms:' + $cur.find('.phone').val(),
                    payment_period: $cur.find('.paymentPeriod').val(),
                    zone: self.zone,
                    success: function(res) {
                        window.location = res.payment_url;
                    }
                });
            },
            validate: {
                rules: {
                    phone: 'required',
                    email: {
                        required: true,
                        email: true
                    }
                },
                messages: {
                    phone: 'Please enter your telephone number',
                    email: 'Please enter a valid email'
                }
            }
        },
        premium_phone: {
            focus: '.phone',
            back: function() { self.showPage('choose_method') },
            submit: function($cur) {
                self.showPage('loading');
                self.addReminder({
                    offset: $cur.find('.customOffset').val(),
                    email: $cur.find('.email').val(),
                    target: 'voice:' + $cur.find('.phone').val(),
                    payment_period: $cur.find('.paymentPeriod').val(),
                    zone: self.zone,
                    success: function(res) {
                        window.location = res.payment_url;
                    }
                });
            },
            validate: {
                rules: {
                    phone: 'required',
                    email: {
                        required: true,
                        email: true
                    }
                },
                messages: {
                    phone: 'Please enter your telephone number',
                    email: 'Please enter a valid email'
                }
            }
        },
        basic_email: {
            focus: '.email',
            back: function() { self.showPage('choose_method') },
            submit: function($cur) {
                self.showPage('loading');
                self.addReminder({
                    offset: $cur.find('.customOffset').val(),
                    email: $cur.find('.email').val(),
                    target: 'email:' + $cur.find('.email').val(),
                    zone: self.zone,
                    success: function() {
                        self.showPage('success');
                    }
                });
            },
            validate: {
                rules: {
                    email: {
                        required: true,
                        email: true
                    }
                },
                messages: {
                    email: 'Please enter a valid email'
                }
            }
        },
        basic_twitter: {
            focus: '.twitter',
            back: function() { self.showPage('choose_method') },
            submit: function($cur) {
                self.showPage('loading');
                self.addReminder({
                    offset: $cur.find('.customOffset').val(),
                    email: $cur.find('.email').val(),
                    target: 'twitter:' + $cur.find('.twitter').val(),
                    zone: self.zone,
                    success: function() {
                        self.showPage('success');
                    }
                });
            },
            validate: {
                rules: {
                    twitter: 'required',
                    email: {
                        required: true,
                        email: true
                    }
                },
                messages: {
                    twitter: 'Please enter your twitter username',
                    email: 'Please enter a valid email'
                }
            }
        }
        */
    },

    showZoneAt: function(lat, lng) {
        var self = this;
        var zone = [ lat, lng ].join(',');
        $.ajax({
            url: '/zones/' + zone + '.json',
            success: function(data) {
                self.setHash('zones', data.name);
            },
            error: function(xhr) {
                $('#wizard .status').html(
                    Jemplate.process('error', {
                        msg: xhr.responseText
                    })
                );
            }
        });
    },

    showPage: function() {
        var args = $.makeArray(arguments);
        var name = args.shift();

        var page = this.pages[name];
        if (!page) throw new Error('Unknown wizard step: ' + name);

        page.apply(this, args);
    },

    changeHeight: function(height, callback) {
        var props = {
            height: height + 'px',
            marginTop: (-height/2) + 'px'
        };
        var once = false;
        $('#main, #whiteBar').animate(props, 'slow', 'swing', function() {
            if (once) return;
            once = true;
            callback();
        });
    },

    changePage: function($newPage, callback) {
        var self = this;
        $newPage
            .css('left', $(window).width()) // render offscreen
            .appendTo('#wizard');

        self.adjustHeight();

        // animate out
        var $old = self.$currentPage;
        $old.animate({ left: - $(window).width() }, 'slow', function(){
            $old.remove();
        });

        // animate in
        $newPage.animate({ left: 0 }, 'slow', function() {
            self.$currentPage = $newPage;
            callback();
        });
    },

    show: function(opts, callback) {
        var self = this;

        // Create the new page
        var $newPage = $(Jemplate.process(opts.page, opts));
        var new_height = opts.height || 200;

        if (self.$currentPage) {
            if (new_height > self.$currentPage.height()) {
                // if the new page is taller, adjust height first
                self.changeHeight(new_height, function() {
                    self.changePage($newPage, function() {
                        self.inProgress = false;
                        callback();
                    });
                });
            }
            else {
                // Otherwise, change the height after the current page is gone
                self.changePage($newPage, function() {
                    self.changeHeight(new_height, function() {
                        self.inProgress = false;
                        callback();
                    });
                });
            }
        }
        else {
            self.changeHeight(new_height, function() {
                // first time
                self.$currentPage = $newPage.appendTo('#wizard');
                self.adjustHeight();
                self.inProgress = false;
                callback();
            });
        }
    },

    // Build a hash of component types to their short name, like 
    //  {locality: 'Vancouver', country: 'CA', ...}
    addressComponentHash: function(address) {
        var hash = {};
        $.each(address.address_components, function(i, component) {
            $.each(component.types, function(i, type) {
                hash[type] = component.short_name;
            });
        });
        return hash;
    },

    restrictLocalities: function(results) {
        return results;
        var self = this;

        var validCities = [
            {locality: 'Vancouver', country: 'CA'}
        ];

        return $.grep(results, function(result) {
            var address = self.addressComponentHash(result);

            // Return a positive number if the result is in any validCity
            return $.grep(validCities, function(city) {
                var valid = true;
                $.each(city, function(key, val) {
                    if (address[key] != val) valid = false;
                });
                return valid;
            }).length;
        });
    },

    adjustHeight: function() {
        var self = this;

        // position middle:
        $('#wizard .middle').each(function(i, node) {
            $(node).css({ marginTop: (0 - $(node).height() / 2) + 'px' });
        });
    },

    getZone: function(name, callback) {
        var self = this;
        $.getJSON('/zones/' + name + '.json', function (zone) {
            $.getJSON('/zones/' + name + '/nextpickup.json', function (next) {
                var yard = '';
                zone.next = next.next[0];
                if (zone.next.match(/^(\d+)-(\d+)-(\d+)(?: (Y))?/)) {
                    var nextDate = new Date;
                    nextDate.setFullYear(RegExp.$1);
                    nextDate.setMonth(RegExp.$2-1);
                    nextDate.setDate(RegExp.$3);
                    zone.next = [
                        self.dayNames[nextDate.getDay()],
                        self.monthNames[nextDate.getMonth()],
                        nextDate.getDate(),
                        nextDate.getFullYear()
                    ].join(' ');
                    zone.yard_msg = RegExp.$4
                        ? ' (Yard trimmings will be picked up)'
                        : ' (Yard trimmings will NOT be picked up)'
                }
                callback(zone);
            });
        });
    },


    setHash: function() {
        var args = $.makeArray(arguments);
        if (args.length) location.hash = '!/' + args.join('/');
    },

    showCalendar: function(zone) {
        $.getJSON('/zones/' + zone.name + '/pickupdays.json', function (days) {
            /* Make a hash of days */
            var pickupdays = {};
            var yarddays = {};
            $.each(days, function(i,d) {
                var key = [d.year,Number(d.month),Number(d.day)].join('-');
                pickupdays[key] = true;
                if (d.flags == 'Y') {
                    yarddays[key] = true
                }
            });

            $('#wizard .calendar').datepicker({
                beforeShowDay: function(day) {
                    var key = [
                        day.getFullYear(), day.getMonth()+1, day.getDate()
                    ].join('-');
                    var className = 'day';
                    if (pickupdays[key]) className += ' marked';
                    if (yarddays[key]) className += ' yard';
                    return [ false, className ];
                }
            });
        });
    },

    showMap: function(zone) {
        var node = $('#wizard .map').get(0);
        var map = new google.maps.Map(node, {
            zoom: 13,
            center: new google.maps.LatLng(49.24702, -123.125542),
            mapTypeId: google.maps.MapTypeId.ROADMAP,
            disableDefaultUI: true
        });

        var parser = new geoXML3.parser({
            map: map,
            processStyles: true,
            afterParse: function(docs) {
                var placemarks = docs[0].placemarks;

                $.each(placemarks, function(i, pmark) {
                    // Clear the info window click handlers
                    var polygon = pmark.polygon;
                    google.maps.event.clearListeners(polygon, 'click');
                    google.maps.event.addListener(polygon, 'click', function(){

                        // Remove all markers
                        $.each(placemarks, function(i, other) {
                            if (other.marker) other.marker.setMap(null);
                        });

                        map.setZoom(12);
                        map.setCenter(polygon.bounds.getCenter());

                        // Add the new Marker
                        pmark.marker = new google.maps.Marker({
                            map: map,
                            draggable: false,
                            animation: google.maps.Animation.DROP,
                            position: polygon.bounds.getCenter()
                        });
                    });

                    if (pmark.name == zone.name) {
                        google.maps.event.trigger(polygon, 'click');
                    }
                });
                return;
            }
        });

        parser.parse('/kml/vancouver.xml');
    },

    feeds: function(zone) {
        var url = location.href + 'zones/' + zone.name + '/pickupdays.ics';
        return [
            {
                name: 'Google Calendar',
                url: 'http://www.google.com/calendar/render?cid=' + url,
                icon: 'google.png',
                id: 'cal-google'
            },
            {
                name: 'iCal',
                url: url.replace('http:', 'webcal:'),
                icon: 'ical.png',
                id: 'cal-ical'
            },
            {
                name: 'Microsoft Outlook',
                url: url,
                icon: 'outlook.png',
                id: 'cal-outlook'
            }
        ];
    },

    wizard: function() {
        var self = this;
        if (self._wizard) return self._wizard;
        var reminder = self.reminder;
        return self._wizard = {
            choose_method: {
                next: function() {
                    self.showPage(self.getValue('reminder-radio'))
                }
            },
        };
    },

    getValue: function(name) {
        return this.$dialog.find('input[name=' + name + ']:checked').val()
    },

    setup: function() {
        this.$dialog.find('a').blur();

        // disable all forms
        this.$dialog.find('form').submit(function() { return false });

        // Telephone fields
        this.$dialog.find('.phone').mask('999-999-9999');

        // Custom time picker
        this.$dialog.find('.simpleOffset').change(function() {
            if ($(this).val() == "custom") {
                $(this).hide();
                $(this).siblings('.customOffset').show();
            }
            else {
                $(this).siblings('.customOffset').val($(this).val());
            }
        })

        this.showPage('choose_method');
    },

    addReminder: function (opts) {
        var data = {
            offset: opts.offset,
            email: opts.email,
            name: "reminder" + (new Date).getTime(),
            target: opts.target
        };
        if (opts.payment_period) data.payment_period = opts.payment_period;
        $.ajax({
            type: 'POST',
            url: '/zones/' + opts.zone + '/reminders',
            data: $.toJSON(data, true),
            error: function(xhr, textStatus, errorThrown) {
                var error = xhr.responseText;
                if (error.match(/^</)) error = errorThrown;
                $('#loading').replaceWith(
                    Jemplate.process('error', { error: error })
                );
            },
            success: opts.success
        });
    }
};

})(jQuery);
