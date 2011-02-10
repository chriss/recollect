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
    validTypes: [ 'street_address', 'intersection', 'postal_code' ],

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
        var self = this;

        var prefix = /^#?!\//;
        var parts = location.hash.replace(prefix, '').split('/');

        $.each(self.pages, function(test, callback) {
            var test_parts = test.replace(prefix, '').split('/');

            var match = true;

            if (test_parts.length == parts.length) {
                var args = {};
                for (var i=0; i < parts.length; i++) {
                    if (test_parts[i].match(/^:(.+)/)) {
                        args[RegExp.$1] = parts[i];
                    }
                    else if (test_parts[i] != parts[i]) {
                        // Not a match
                        match = false;
                        break;
                    }
                }

                if (match) {
                    callback.call(self, args);
                    return false; // early out
                }
            }
        });
    },

    pages: {
        '!/': function() {
            var self = this;
            var opts = {
                height: 200,
                opacity: 0.8,
                page: 'wizardAddress'
            };
            self.show(opts, function() {
                $('#wizard .address').autocomplete({
                    source: [],
                    select: function(evt, ui) {
                        $('#wizard .address').val(ui.item.value)
                        $('#wizard form').submit();
                    }
                });
                $('#wizard .address')
                    .click(function() {
                        $(this).removeClass('initial').val('').unbind('click');
                    })
                    .keyup(function(e) {
                        // Hide the suggestions
                        $('#wizard .status').html('');
                        self.autocomplete($(this));
                    });

                $('#wizard #search').click(function(){
                    $('#wizard form').submit();
                    return false;
                });

                $('#wizard form').submit(function(){
                    try {
                        // Hide the autocomplete
                        $(this).find('.address').blur().focus();
                        self.searchForZone($(this).find('.address').val());
                    }
                    catch(e) {
                        setTimeout(function() { throw e }, 0);
                    }
                    return false;
                });
            });
        },

        '!/notfound/:city': function(args) {
            var opts = {
                height: 300,
                opacity: 1,
                page: 'wizardZoneSuggestion',
            };
            $.extend(opts, args);
            this.show(opts, function() {
            });
        },

        '!/:area/:zone': function(args) {
            var self = this;

            self.getZone(args.area, args.zone, function(zone) {
                var opts = {
                    height: 500,
                    opacity: 1,
                    page: 'wizardZone'
                };
                $.extend(opts, zone);
                self.show(opts, function() {
                    self.showCalendar(zone);
                    self.showMap(zone);
                    $('#wizard #subscribe').click(function(){
                        self.setHash(args.area, args.zone, 'subscribe');
                        return false;
                    });
                });
            });
        },

        '!/:area/:zone/subscribe': function(args) {
            var self = this;

            var opts = {
                height: 500,
                opacity: 1,
                page: 'wizardSubscribe'
            };
            self.getZone(args.area, args.zone, function(zone) {
                $.extend(opts, zone);
                self.show(opts, function() {
                    $('#wizard .next').click(function(){
                        self.setHash(
                            args.area, args.zone, 'subscribe',
                            $('input[name=reminder-radio]:checked').val()
                        );
                        return false;
                    });
                });
            });
        },

        '!/:area/:zone/subscribe/feed': function(args) {
            var self = this;

            self.getZone(args.area, args.zone, function(zone) {
                var opts = {
                    height: 500,
                    opacity: 1,
                    feeds: self.feeds(zone),
                    page: 'wizardFeeds'
                };
                $.extend(opts, zone);
                self.show(opts, function() {
                    $('#wizard .next').click(function(){
                        self.setHash(args.area, args.zone, 'subscribe'); //BACK
                        return false;
                    });
                });
            });
        },

        '!/:area/:zone/subscribe/:type': function(args) {
            var self = this;

            var opts = {
                height: 500,
                opacity: 1,
                page: 'wizardForm'
            };
            $.extend(opts, args);
            self.getZone(args.area, args.zone, function(zone) {
                $.extend(opts, zone);
                self.show(opts, function() {
                    $('#wizard form').validate(self.validate[args.type])
                    $('#wizard input[name=phone]').mask('999-999-9999');
                    $('#wizard .simpleOffset').change(function() {
                        if ($(this).val() == 'custom') {
                            // Show the more advanced time input
                            $(this).hide();
                            $('#wizard .customOffset').show();
                        }
                        else {
                            // Set the simple value in the customOffset select
                            // (which is the *real* offset element)
                            $('#wizard .customOffset').val($(this).val());
                        }
                    });
                    $('#wizard form').submit(function() {
                        var reminder = {
                            area: args.area,
                            zone: args.zone,
                            type: args.type
                        };
                        var form = $('#wizard form').serializeArray();
                        $.each(form, function(i,field) {
                            reminder[field.name] = field.value;
                        });
                        self.addReminder(reminder);
                        return false;
                    });
                    $('#wizard .next').click(function() {
                        $('#wizard form').submit();
                        return false;
                    });
                });
            });
        },

        '!/success': function() {
            var self = this;

            var opts = {
                height: 200,
                opacity: 1,
                page: 'success'
            };
            self.show(opts, function() {
            });
        }
    },

    validate: {
        email: {
            rules: {
                email: {
                    required: true,
                    email: true
                }
            },
            messages: {
                email: 'Please enter a valid email'
            }
        },
        twitter: {
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
        },
        sms: {
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
        },
        phone: {
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

    autocomplete: function($node) {
        var self = this;

        self.geocode({
            address: $node.val(),
            biasViewport: true,
            callback: function(results) {
                results = self.filterLocalities(results);
                if (!results.length) return;
                $node.autocomplete({
                    'source': $.map(results, function(r) {
                        return r.formatted_address;
                    })
                });
            }
        });
    },

    bounds: function() {
        var bounds = new google.maps.LatLngBounds();
        bounds.extend(new google.maps.LatLng(49.198177,-123.22474));
        bounds.extend(new google.maps.LatLng(49.317294,-123.023068));
        return bounds;
    },

    /* This function keeps track of whether we are currently geocoding an
     * address, and defers geocoding new addresses until the current geocoding
     * is complete
     */
    geocode: function(args) {
        var self = this;

        var request = { address: args.address };
        if (args.biasViewport) request.bounds = self.bounds();

        var geocoder = new google.maps.Geocoder();
        geocoder.geocode(request, function(results, status) {
            if (status == google.maps.GeocoderStatus.OK) {
                // restrict results to street addresses
                results = $.grep(results, function(r) {
                    // Show only valid types of locations
                    return $.grep(self.validTypes, function(type) {
                        return $.inArray(type, r.types) > -1
                    }).length;
                });
                args.callback(results);
            }
            else {
                args.callback([]);
            }
        });
    },

    // Build a hash of component types to their short name, like 
    //  {locality: 'Vancouver', country: 'CA', ...}
    addressComponent: function(component_type, result) {
        var value;
        $.each(result.address_components, function(i, component) {
            $.each(component.types, function(i, type) {
                if (type == component_type) value = component.long_name;
            });
        });
        return value;
    },

    cityName: function(result) {
        var parts = [];
        var locality = this.addressComponent('locality', result)
        if (locality) {
            // Ideally we have a locality!
            return [
                locality,
                this.addressComponent('administrative_area_level_1', result),
                this.addressComponent('country', result),
            ].join(', ');
        }

        // Otherwise, string together the political components
        $.each(result.address_components, function(i, component) {
            if ($.inArray('political', component.types) > -1) {
                parts.push(component.long_name);
            }
        });
        return parts.join(', ');
    },

    filterLocalities: function(results) {
        var self = this;

        var validCities = [
            {locality: 'Vancouver', country: 'Canada'}
        ];

        return $.grep(results, function(res) {
            return $.grep(validCities, function(city) {
                var valid = true;
                $.each(city, function(key, val) {
                    if (self.addressComponent(key, res) != val) valid = false;
                });
                return valid;
            }).length;
        });
    },

    showAddressSelection: function(results, callback) {
        $('#wizard .status').html(
            Jemplate.process('addresses', {
                results: results
            })
        );
        $.each(results, function(i, result) {
            var link = $('#wizard .status a').get(i);
            $(link).click(function() {
                $('#wizard .status').fadeOut(function() { callback(result) });
                return false;
            });
        });
    },

    searchForZone: function(address) {
        var self = this;

        self.geocode({
            address: address,
            callback: function(results) {
                if (results.length) {
                    var filtered = self.filterLocalities(results);
                    if (filtered.length == 1) {
                        self.showZoneAt(filtered[0]);
                    }
                    else if (filtered.length == 0) {
                        if (results.length == 1) {
                            // suggest results[0]
                            self.setHash('notfound', self.cityName(results[0]));
                        }
                        else {
                            // show a list of results to suggest
                            self.showAddressSelection(results, function(r) {
                                self.setHash('notfound', self.cityName(r));
                            });
                        }
                    }
                    else {
                        // show a list of filtered to select from
                        self.showAddressSelection(filtered, function(result) {
                            self.showZoneAt(result);
                        });
                    }
                }
                else {
                    // Error: zero results
                    $('#wizard .status').html(
                        Jemplate.process('error', { msg: "Found 0 Results" })
                    );
                }
            }
        });
    },

    storeLocation: function(lat, lng) {
        $.cookie('LatLng', [lat,lng].join(','), { expires: 365 });
    },

    getLocation: function() {
        var coord_string = $.cookie('LatLng');
        if (!coord_string) return;

        coord_array = coord_string.split(',');
        return new google.maps.LatLng(coord_array[0], coord_array[1]);
    },

    showZoneAt: function(result) {
        var self = this;

        // show this address
        var loc = result.geometry.location;
        var locality = self.addressComponent('locality', result);

        // Store user's lat, lng
        self.storeLocation(loc.lat(), loc.lng());

        var zone = [ loc.lat(), loc.lng() ].join(',');
        $.ajax({
            url: '/api/areas/' + locality + '/zones/' + zone + '.json',
            success: function(data) {
                self.setHash(locality, data.name);
            }
        });
    },

    changeHeight: function(height, callback) {
        var props = {
            height: height + 'px',
            marginTop: (-height/2 - 20) + 'px'
        };
        var once = false;
        $('#wizardLayout').animate(props, 'slow', 'swing', function() {
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

    adjustHeight: function() {
        var self = this;

        // position middle:
        $('#wizard .middle').each(function(i, node) {
            $(node).css({ marginTop: (0 - $(node).height() / 2) + 'px' });
        });
    },

    getZone: function(area, name, callback) {
        var self = this;

        // Cache zone info
        if (typeof(self._zoneCache) == 'undefined') self._zoneCache = {};
        if (typeof(self._zoneCache[area]) == 'undefined') self._zoneCache[area] = {};
        if (self._zoneCache[area][name]) {
            callback(self._zoneCache[area][name]);
            return;
        }

        var url = '/api/areas/' + area + '/zones/' + name + '.json?verbose=1';
        $.getJSON(url, function (zone) {
            var yard = '';
            zone.next = zone.nextpickup.day;
            var ymd = zone.next.split('-');
            var nextDate = new Date;
            nextDate.setFullYear(ymd[0]);
            nextDate.setMonth(ymd[1]-1);
            nextDate.setDate(ymd[2]);
            zone.next = [
                self.dayNames[nextDate.getDay()],
                self.monthNames[nextDate.getMonth()],
                nextDate.getDate(),
                nextDate.getFullYear()
            ].join(' ');
            zone.yard_msg = zone.nextpickup.flags.match(/Y/)
                ? ' (Yard trimmings will be picked up)'
                : ' (Yard trimmings will NOT be picked up)'
            self._zoneCache[area][name] = zone; // store cached value
            callback(zone);
        });
    },


    setHash: function() {
        var args = $.makeArray(arguments);
        if (args.length) location.hash = '!/' + args.join('/');
    },

    showCalendar: function(zone) {
        /* Make a hash of days */
        var pickupdays = {};
        var yarddays = {};
        $.each(zone.pickupdays, function(i,d) {
            var ymd = d.day.split('-');
            var key = [ymd[0],Number(ymd[1]),Number(ymd[2])].join('-');
            pickupdays[key] = true;
            if (d.flags.match(/Y/)) {
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

        $('#wizard .calendar .ui-datepicker-inline').append(
            Jemplate.process('legend')
        );
    },

    showMap: function(zone) {
        var self = this;

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

                // For zones with multiple polygons 
                var foundLocation = false;

                $.each(placemarks, function(i, pmark) {
                    if (!foundLocation && pmark.name == zone.name) {
                        // Add a new Marker
                        var position = pmark.polygon.bounds.getCenter();
                        var stored = self.getLocation();
                        if (stored && polygonContains(pmark.polygon, stored)) {
                            foundLocation = true;
                            position = stored;
                        }

                        map.setCenter(position);
                        pmark.marker = new google.maps.Marker({
                            map: map,
                            draggable: false,
                            animation: google.maps.Animation.DROP,
                            position: position
                        });

                        map.setZoom(12);
                    }
                });
                return;
            }
        });

        parser.parse('/kml/vancouver.xml');
    },

    feeds: function(zone) {
        var url = location.href.replace(/#.*$/,'')
            + 'api/areas/' + zone.area.name + '/zones/'
            + zone.name + '/pickupdays.ics'
            + '?t=' + (new Date).getTime();

        return [
            {
                name: 'Google Calendar',
                url: 'http://www.google.com/calendar/render?cid='
                    + encodeURIComponent(url),
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

    addReminder: function (opts) {
        var self = this;

        $('#wizard .subscription').append(Jemplate.process('loading'));
        $('#wizard .subscription form').hide();

        var data = {
            email: opts.email,
            reminders: []
        };

        var reminder = {
            delivery_offset: opts.offset,
            zone_id: opts.zone,
            area: opts.area
        };

        if (opts.payment_period) reminder.payment_period = opts.payment_period;

        switch(opts.type) {
            case 'email':   reminder.target = 'email:' + opts.email;     break;
            case 'twitter': reminder.target = 'twitter:' + opts.twitter; break;
            case 'sms':     reminder.target = 'sms:' + opts.phone;       break;
            case 'phone':   reminder.target = 'phone:' + opts.phone;     break;
        }

        data.reminders.push(reminder);

        $.ajax({
            type: 'POST',
            url: '/api/subscriptions',
            contentType: 'json',
            data: $.toJSON(data, true),
            error: function(xhr, textStatus, errorThrown) {
                var error = $.evalJSON(xhr.responseText)
                
                // reshow the form
                $('#wizard .subscription .loading').remove();
                $('#wizard .subscription form').show();

                $('#subscriptionError').html(
                    Jemplate.process('error', { msg: error.msg })
                );
            },
            success: function(data) {
                if (data.payment_url) {
                    location = data.payment_url;
                }
                else {
                    self.setHash('success');
                }
            }
        });
    }
};

})(jQuery);
