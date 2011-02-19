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
                height: 300,
                opacity: 0.8,
                page: 'wizardWelcome'
            };
            self.show(opts, function() {
                $('#start').click(function(){
                    self.setHash('start');
                    return false;
                });
            });
        },

        '!/start': function() {
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
                        if (e.keyCode == 13) return; // ignore Enter

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

        '!/interest/:lat/:lng': function(args) {
            var self = this;
            var opts = {
                height: 300,
                opacity: 1,
                page: 'wizardZoneSuggestion'
            };
            $.extend(opts, args);
            self.show(opts, function() {
                var latlng = new google.maps.LatLng(args.lat, args.lng);
                var map = self.showMap();
                self.showPointOnMap(map, latlng);

                $('.interest form').submit(function() {
                    $('.interest .loading').show();
                    $('.interest form').hide();
                    var email = $('.interest input[name=email]').val();
                    $.ajax({
                        type: 'POST',
                        url: '/api/interest/' + latlng.toUrlValue() + '/notify',
                        data: { email: email },
                        error: function(xhr, textStatus, errorThrown) {
                            $('.interest form').show();
                            $('.interest .loading').hide();
                            $('#wizard .status').html(
                                Jemplate.process('error', { msg: "Error" })
                            );
                        },
                        success: function() {
                            self.setHash(); // Redirect to /
                        }
                    });
                    return false;
                });
                $('.interest .submit').click(function() {
                    $('.interest form').submit();
                    return false;
                });
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
                    var map = self.showMap();
                    self.showZoneOnMap(map, args.area, zone);
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
                    $('#wizard .chooseText').click(function(){
                        self.setHash(args.area, args.zone, 'subscribe', 'text');
                        return false;
                    });
                    $('#wizard .chooseVoice').click(function(){
                        self.setHash(args.area, args.zone, 'subscribe', 'voice');
                        return false;
                    });
                    $('#wizard .chooseFree').click(function(){
                        self.setHash(args.area, args.zone, 'subscribe', 'free');
                        return false;
                    });
                });
            });
        },

        '!/:area/:zone/subscribe/free': function(args) {
            var self = this;

            self.getZone(args.area, args.zone, function(zone) {
                var opts = {
                    height: 500,
                    opacity: 1,
                    feeds: self.feeds(zone),
                    page: 'wizardFree'
                };
                $.extend(opts, zone);
                self.show(opts, function() {
                    $('#wizard .chooseEmail').click(function(){
                        self.setHash(
                            args.area, args.zone, 'subscribe', 'free', 'email'
                        );
                        return false;
                    });
                    $('#wizard .chooseTwitter').click(function(){
                        self.setHash(
                            args.area, args.zone, 'subscribe', 'free', 'twitter'
                        );
                        return false;
                    });
                });
            });
        },

        '!/:area/:zone/subscribe/:type': function(args) {
            var self = this;

            self.getZone(args.area, args.zone, function(zone) {
                var opts = {
                    height: 500,
                    opacity: 1,
                    feeds: self.feeds(zone),
                    page: 'wizardPremium'
                };
                $.extend(opts, zone);
                self.show(opts, function() {
                    $('#wizard .chooseQuarterly').click(function(){
                        self.setHash(
                            args.area, args.zone, 'subscribe',
                            args.type, 'quarterly'
                        );
                        return false;
                    });
                    $('#wizard .chooseAnnual').click(function(){
                        self.setHash(
                            args.area, args.zone, 'subscribe',
                            args.type, 'annual'
                        );
                        return false;
                    });
                });
            });
        },

        '!/:area/:zone/subscribe/free/:type': function(args) {
            this.showForm(args);
        },

        '!/:area/:zone/subscribe/:type/:paycycle': function(args) {
            this.showForm(args);
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
        text: {
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
        voice: {
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

    showForm: function(args) {
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
                }).change();
                $('#wizard form').submit(function() {
                    var reminder = {
                        area: args.area,
                        zone: args.zone,
                        type: args.type,
                        payment_period: args.paycycle
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

    autocomplete: function($node) {
        var self = this;

        self.geocode({
            address: $node.val(),
            biasViewport: true,
            callback: function(results) {
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
        if (args.biasViewport) request.region = 'ca';

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
            else if (status == google.maps.GeocoderStatus.ZERO_RESULTS) {
                args.callback([]);
            }
            else if (status == google.maps.GeocoderStatus.OVER_QUERY_LIMIT) {
                if (args.force) {
                    setTimeout(function() { self.geocode(args) }, 500);
                }
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

    showAddressSelection: function(results, callback) {
        $('#wizard .status').html(
            Jemplate.process('addresses', {
                results: results
            })
        );
        $.each(results, function(i, result) {
            var link = $('#wizard .status a').get(i);
            $(link).click(function() {
                $('#wizard .status').fadeOut(function() {
                    callback(result.formatted_address);
                });
                return false;
            });
        });
    },

    searchForZone: function(address) {
        var self = this;

        self.geocode({
            force: true,
            address: address,
            biasViewport: true,
            callback: function(results) {
                if (results.length == 1) {
                    self.showZoneAt(results[0]);
                }
                else if (results.length > 1) {
                    // show a list of results to suggest
                    self.showAddressSelection(results, function(address) {
                        self.searchForZone(address);
                    });
                }
                else {
                    // Error: zero results
                    $('#wizard .status').html(
                        Jemplate.process('error', {
                            msg: "Sorry, we couldn't find your address."
                        })
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
            url: '/api/lookup/' + zone + '.json',
            success: function(data) {
                self.setHash(data.area.name, data.name);
            },
            error: function(xhr) {
                if (xhr.status == 404) {
                    self.setHash('interest', loc.lat(), loc.lng());
                }
                else {
                    // Error: zero results
                    $('#wizard .status').html(
                        Jemplate.process('error', {
                            msg: "Error Loading Result!"
                        })
                    );
                }
            }
        });
    },

    changeHeight: function(height, callback) {
        var props = {
            height: height + 'px',
            marginTop: (-height/2 - 15) + 'px'
        };
        var once = false;
        $('#smallLayout').animate(props, 'slow', 'swing', function() {
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
        opts.version = self.version;
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
        if (!args.length) location.hash = '';
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

    showPointOnMap: function(map, position) {
        map.setCenter(position);
        var marker = new google.maps.Marker({
            map: map,
            draggable: false,
            animation: google.maps.Animation.DROP,
            position: position
        });
        map.setZoom(12);
        return marker
    },

    showZoneOnMap: function(map, area, zone) {
        var self = this;
        var stored = self.getLocation();
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
                        if (stored && polygonContains(pmark.polygon, stored)) {
                            foundLocation = true;
                            position = stored;
                        }
                        self.showPointOnMap(map, position);
                    }
                });
                return;
            }
        });
        parser.parse('/api/areas/' + area + '/zones/' + zone.name + '.kml');
    },

    showMap: function(position, zone) {
        var self = this;

        if (!position) position = self.getLocation();
        if (!position) throw new Error('Missing position');

        var node = $('#wizard .map').get(0);
        var map = new google.maps.Map(node, {
            zoom: 13,
            center: position,
            mapTypeId: google.maps.MapTypeId.ROADMAP,
            disableDefaultUI: true
        });

        return map;
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

        $('#wizard .subscription .loading').show();
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

        if (opts.payment_period) data.payment_period = opts.payment_period;

        switch(opts.type) {
            case 'email':   reminder.target = 'email:' + opts.email;     break;
            case 'twitter': reminder.target = 'twitter:' + opts.twitter; break;
            case 'text':    reminder.target = 'sms:' + opts.phone;       break;
            case 'voice':   reminder.target = 'voice:' + opts.phone;     break;
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
                $('#wizard .subscription .loading').hide();
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
