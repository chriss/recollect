(function($) {

Recollect.Wizard  = function(opts) {
    $.extend(this, this._defaults, opts);
}

jQuery.validator.addMethod("phone", function(phone, element) {
    return this.optional(element)
        || phone.match(/^[2-9]\d{2}-[2-9]\d{2}-\d{4}$/);
}, "Please specify a valid phone number");

Recollect.Wizard.prototype = new Recollect;

$.extend(Recollect.Wizard.prototype, {
    _defaults: {
        _showQueue: []
    },

    dayNames: [
        'Sunday','Monday','Tuesday', 'Wednesday','Thursday','Friday','Saturday'
    ],
    monthNames: [
        'January','February','March','April','May','June',
        'July','August','September','October','November','December'
    ],
    validTypes: [ 'street_address', 'intersection', 'postal_code' ],

    start: function() {
        var self = this;

        $('#wizard').html(Jemplate.process('wizard'));

        $('.homeLink').click(function() {
            self.setLocation('/');
            return false;
        });
        $('.tell-a-friend').click(function() {
            self.setLocation('/r/tell-a-friend');
            return false;
        });

        Recollect.prototype.start.call(self);
    },

    pages: {
        '/': function() {
            var self = this;

            var opts = {
                opacity: 0.8,
                page: 'wizardWelcome'
            };
            self.show(opts, function() {
                $('#start').click(function(){
                    self.setLocation('/r/start');
                    return false;
                });
            });
        },

        '/r/start': function() {
            var self = this;

            var opts = {
                height: 200,
                opacity: 0.8,
                page: 'wizardAddress'
            };
            self.show(opts, function() {
                $('#wizard .address')
                    .autocomplete({
                        source: [],
                        select: function(evt, ui) {
                            $('#wizard .address').val(ui.item.value)
                            $('#wizard form').submit();
                        }
                    })
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

        '/r/interest/:lat/:lng': function(args) {
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
                            self.setLocation('/'); // Redirect to /
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

        '/r/success': function() {
            var self = this;
            var opts = {
                height: 200,
                opacity: 1,
                page: 'success'
            };
            self.show(opts, function() {
            });
        },

        '/r/tell-a-friend': function() {
            var self = this;
            var opts = {
                height: 200,
                opacity: 1,
                page: 'tell_a_friend'
            };
            self.show(opts, function() {});
        },

        '/r/:zone': function(args) {
            var self = this;
            self.trackEvent('zone', args.zone);

            self.getZone(args.zone, function(zone) {
                var opts = {
                    height: 550,
                    opacity: 1,
                    page: 'wizardZone'
                };
                $.extend(opts, zone);
                self.show(opts, function() {
                    self.showCalendar(zone);
                    var map = self.showMap();
                    self.showZoneOnMap(map, zone);
                    $('#wizard #subscribe').click(function(){
                        self.setLocation('/r', args.zone, 'subscribe');
                        return false;
                    });
                    $('#wizard .wrongZone').click(function(){
                        self.setLocation('/r/start');
                        self.trackEvent('zone.wrong_zone', args.zone);
                        return false;
                    })
                });
            });
        },

        '/r/:zone/subscribe': function(args) {
            var self = this;

            var opts = {
                height: 500,
                opacity: 1,
                page: 'wizardSubscribe'
            };
            self.getZone(args.zone, function(zone) {
                $.extend(opts, zone);
                self.show(opts, function() {
                    $('#wizard .chooseText').click(function(){
                        self.setLocation('/r', args.zone, 'subscribe', 'text');
                        return false;
                    });
                    $('#wizard .chooseVoice').click(function(){
                        self.setLocation('/r', args.zone, 'subscribe','voice');
                        return false;
                    });
                    $('#wizard .chooseFree').click(function(){
                        self.setLocation('/r', args.zone, 'subscribe', 'free');
                        return false;
                    });
                    $('#wizard .back').click(function() {
                        // Track clicking back from pay
                        self.trackEvent('subscribe.back', args.zone);
                        self.setLocation('/r', args.zone);
                        return false;
                    });
                });
            });
        },

        '/r/:zone/subscribe/free': function(args) {
            var self = this;

            self.getZone(args.zone, function(zone) {
                var opts = {
                    height: 500,
                    opacity: 1,
                    feeds: self.feeds(zone),
                    page: 'wizardFree'
                };
                $.extend(opts, zone);
                self.show(opts, function() {
                    $('#wizard .chooseEmail').click(function(){
                        self.setLocation('/r', args.zone, 'subscribe', 'free', 'email');
                        return false;
                    });
                    $('#wizard .chooseTwitter').click(function(){
                        self.setLocation('/r', args.zone, 'subscribe', 'free', 'twitter');
                        return false;
                    });
                    $('#wizard .back').click(function() {
                        // Track clicking back from free
                        self.trackEvent('subscribe.free.back', args.zone);
                        self.setLocation('/r', args.zone, 'subscribe');
                        return false;
                    });

                    // Track clicking on calendars in Google Analytics
                    $('#wizard .feed a').click(function() {
                        self.trackEvent(
                            'subscribe.calendar',
                            [args.zone, $(this).attr('id')]
                        );
                    });
                });
            });
        },

        '/r/:zone/subscribe/:type': function(args) {
            var self = this;

            self.getZone(args.zone, function(zone) {
                var opts = {
                    height: 500,
                    opacity: 1,
                    feeds: self.feeds(zone),
                    page: 'wizardPremium'
                };
                $.extend(opts, zone);
                self.show(opts, function() {
                    $('#wizard .chooseQuarterly').click(function(){
                        self.setLocation( '/r',
                            args.zone, 'subscribe',
                            args.type, 'quarterly'
                        );
                        return false;
                    });
                    $('#wizard .chooseAnnual').click(function(){
                        self.setLocation( '/r',
                            args.zone, 'subscribe',
                            args.type, 'annual'
                        );
                        return false;
                    });
                    $('#wizard .chooseOnline').click(function() {
                        // Track clicking back from pay
                        self.trackEvent(
                            'subscribe.pay.free', [args.type, args.zone]
                        );
                        self.setLocation('/r', args.zone, 'subscribe', 'free');
                        return false;
                    });
                    $('#wizard .back').click(function() {
                        // Track clicking back from pay
                        self.trackEvent(
                            'subscribe.pay.back', [args.type, args.zone]
                        );
                        self.setLocation('/r', args.zone, 'subscribe');
                        return false;
                    });
                });
            });
        },

        '/r/:zone/subscribe/free/:type': function(args) {
            this.showForm(args);
        },

        '/r/:zone/subscribe/:type/:paycycle': function(args) {
            this.showForm(args);
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
                phone: {
                    required: true,
                    phone: true
                },
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
                phone: {
                    required: true,
                    phone: true
                },
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
            location: self.getLocation(),
            page: 'wizardForm'
        };
        $.extend(opts, args);
        self.getZone(args.zone, function(zone) {
            $.extend(opts, zone);
            self.show(opts, function() {
                $('#wizard form').validate(self.validate[args.type])
                $('#wizard input[name=phone]').mask('999-999-9999');
                $('#wizard .address').keyup(function(e) {
                    self.autocomplete($(this));
                });
                $('#wizard .time').timePicker({
                    show24Hours: false,
                    step: 30
                });
                $('#wizard form').submit(function() {
                    if ($(this).valid()) {
                        self.submitReminderForm(args);
                    }
                    return false;
                });
                $('#wizard .next').click(function() {
                    $('#wizard form').submit();
                    return false;
                });
                $('#wizard .back').click(function() {
                    var page = args.paycycle ? args.type : 'free';
                    self.trackEvent(
                        'subscribe.form.back',
                        [args.zone, args.type, args.paycycle || 'free']
                    );
                    self.setLocation('/r', args.zone, 'subscribe', page);
                    return false;
                });
            });
        });
    },

    autocomplete: function($node) {
        var self = this;

        var timout = $node.data('timout');
        if (timout) clearTimeout(timout);

        $node.data('timout', setTimeout(function() {
            self.geocode({
                address: $node.val(),
                biasViewport: true,
                callback: function(results) {
                    if (!results.length) return;
                    $node.autocomplete({
                        'minLength': 0,
                        'source': $.map(results, function(r) {
                            return r.formatted_address;
                        })
                    });
                    $node.autocomplete('search', '');
                }
            });
        }, 250));
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
                    callback(result);
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
                    self.showAddressSelection(results, function(result) {
                        self.searchForZone(result.formatted_address);
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

    storeLocation: function(loc) {
        if (loc) {
            $.cookie('lat', loc.lat());
            $.cookie('lng', loc.lng());
        }
    },

    getLocation: function() {
        var lat = $.cookie('lat');
        var lng = $.cookie('lng');
        if (lat || lng) return new google.maps.LatLng(lat, lng);
    },

    showZoneAt: function(result) {
        var self = this;

        // show this address
        var loc = result.geometry.location;
        var locality = self.addressComponent('locality', result);

        // Store user's lat, lng
        self.storeLocation(loc);

        var zone = [ loc.lat(), loc.lng() ].join(',');
        $.ajax({
            url: '/api/lookup/' + zone + '.json',
            success: function(data) {
                self.setLocation('/r', data.name);
            },
            error: function(xhr) {
                if (xhr.status == 404) {
                    self.setLocation('/r/interest', loc.lat(), loc.lng());
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
            marginTop: (-height/2 + 15) + 'px'
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
            .appendTo('#smallLayout');

        self.adjustHeight();

        var opts = {};

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

        if (self.inProgress) {
            self._showQueue.push([opts, callback]);
            return;
        }
        self.inProgress = true;

        // Create the new page
        opts.version = self.version;
        var html = Jemplate.process(opts.page, opts);
        var $newPage = $(html);

        $newPage.find('.homeLink').click(function() {
            self.setLocation('/');
            return false;
        });

        var doneShow = function() {
            self.inProgress = false;
            callback();
            var next = self._showQueue.shift();
            if (next) self.show(next[0], next[1]);
        }

        var new_height = self.determineHeights($newPage);

        if (self.$currentPage) {
            if (new_height > self.$currentPage.height()) {
                // if the new page is taller, adjust height first
                self.changeHeight(new_height, function() {
                    self.changePage($newPage, doneShow);
                });
            }
            else {
                // Otherwise, change the height after the current page is gone
                self.changePage($newPage, function() {
                    self.changeHeight(new_height, doneShow);
                });
            }
        }
        else {
            self.changeHeight(new_height, function() {
                // first time
                self.$currentPage = $newPage.appendTo('#smallLayout');
                self.adjustHeight();
                doneShow();
            });
        }
    },

    determineHeights: function($newPage) {
        // Figure out heights
        var new_height = 0;
        $.each($newPage.find('.row'), function(_, row) {
            var rowHeight = Number($(row).attr('height')) || 200;
            $(row).css('height', rowHeight + 'px');
            new_height += rowHeight;

            // Now offset left/right based on their heights
            $(row).find('.left, .right, .center').each(function(_, side) {
                var height = Number($(side).attr('height'));
                if (height) {
                    var sideHeight = (rowHeight - height) / 2;
                    $(side).css('margin-top', sideHeight + 'px');

                    // Prevent the margin-top from overlapping 
                    $(window).resize(function() {
                        console.log($(window).height(), sideHeight);
                    });
                }
            });
        });
        $newPage.css('height', new_height + 'px');
        return new_height;
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

        // Cache zone info
        if (typeof(self._zoneCache) == 'undefined') self._zoneCache = {};
        if (self._zoneCache[name]) {
            callback(self._zoneCache[name]);
            return;
        }

        var url = '/api/lookup/' + name + '.json';
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
            self._zoneCache[name] = zone; // store cached value
            callback(zone);
        });
    },

    showCalendar: function(zone) {
        var self = this;

        var pickup_day = {};
        var legend = {};
        var legend_cnt = 1;

        /* Make a hash of days */
        $.each(zone.pickupdays, function(i,d) {
            var ymd = d.day.split('-');
            ymd = [ymd[0],Number(ymd[1]),Number(ymd[2])].join('-');

            // Store the proper class for these flags
            pickup_day[ymd] = legend[d.flags]
                = legend[d.flags] || 'legend' + legend_cnt++;
        });

        $('#wizard .calendar').datepicker({
            beforeShowDay: function(day) {
                // Colour the day
                var ymd = [
                    day.getFullYear(), day.getMonth()+1, day.getDate()
                ].join('-');
                if (pickup_day[ymd]) {
                    return [false, 'day ' + pickup_day[ymd]];
                }
                else {
                    return [false, 'day'];
                }

            }
        });

        // render the legend
        $('#wizard .calendar').append(
            Jemplate.process('legend', {
                keys: legend,
                names: {
                    G: 'Garbage',
                    R: 'Recycling',
                    Y: 'Yard',
                    C: 'Compost'
                }
            })
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

    showZoneOnMap: function(map, zone) {
        var self = this;
        var parser = new geoXML3.parser({
            map: map,
            processStyles: true,
            afterParse: function(docs) {
                if (!self.getLocation()) return;
                var placemarks = docs[0].placemarks;
                $.each(placemarks, function(i, pmark) {
                    if (polygonContains(pmark.polygon, self.getLocation())) {
                        self.showPointOnMap(map, self.getLocation());
                    }
                });
            }
        });
        parser.parse('/api/lookup/' + zone.name + '.kml');
    },

    showMap: function(position, zone) {
        var self = this;
        var node = $('#wizard .map').get(0);
        var map = new google.maps.Map(node, {
            zoom: 13,
            center: self.getLocation(),
            mapTypeId: google.maps.MapTypeId.ROADMAP,
            disableDefaultUI: true
        });

        return map;
    },

    feeds: function(zone) {
        var url = location.protocol + '//' + location.host
            + '/api/lookup/' + zone.name + '/pickupdays.ics'
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

    // Calculate offset
    // XXX: We should change this so we can just pass a time instead of
    // making this calculation
    calculateOffset: function(opts) {
        var minutes = opts.time.getHours() * 60;
        minutes += opts.time.getMinutes();

        if (opts.day == 'day_before') {
            minutes -= 24 * 60; // Go back one day
        }

        var offset = 7*60 - minutes;

        var hours = Math.floor(offset / 60);
        var minutes = offset - hours*60;

        if (String(hours).length < 2) hours = '0' + hours;
        if (String(minutes).length < 2) minutes = '0' + minutes;

        return hours + ':' + minutes;
    },

    submitReminderForm: function(args) {
        var self = this;

        var reminder = {
            zone: args.zone,
            type: args.type,
            payment_period: args.paycycle
        };

        var form = $('#wizard form').serializeArray();
        $.each(form, function(i,field) {
            reminder[field.name] = field.value;
        });

        // Grab the time out of the timepicker
        reminder.time = $.timePicker('#wizard .time').getTime();

        if (typeof(reminder.address) == 'undefined') {
            self.addReminder(reminder);
        }
        else {
            self.geocode({
                force: true,
                address: reminder.address,
                biasViewport: true,
                callback: function(results) {
                    if (results.length == 1) {
                        self.storeLocation(results[0].geometry.location);
                        self.addReminder(reminder);
                    }
                    else if (results.length > 1) {
                        self.showError(
                            '#wizard .address',
                            "Sorry, we couldn't find your address."
                        );
                    }
                    else {
                        self.showError(
                            '#wizard .address',
                            "Sorry, we couldn't find your address."
                        );
                    }
                }
            });
        }
    },

    showError: function(node, error) {
        $(node).addClass('error');
        $('<label></label>')
            .addClass('error')
            .attr('for', $(node).attr('name'))
            .css('display', 'inline')
            .html("Sorry, we couldn't find your address.")
            .insertAfter(node);
    },

    addReminder: function (opts) {
        var self = this;

        $('#wizard .subscription .loading').show();
        $('#wizard .subscription form').hide();

        var data = {
            email: opts.email,
            location: wizard.getLocation().toUrlValue(),
            reminders: []
        };

        var reminder = {
            delivery_offset: self.calculateOffset(opts),
            zone_id: opts.zone
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
            data: JSON.stringify(data),
            error: function(xhr, textStatus, errorThrown) {
                var error = JSON.parse(xhr.responseText)
                
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
                    self.setLocation('/r/success');
                }
            }
        });
    }
});

})(jQuery);
