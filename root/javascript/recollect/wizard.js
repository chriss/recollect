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
                            var locality = self.addressComponent(
                                'locality', results[0]
                            );
                            self.showZoneAt(locality, loc.lat(), loc.lng());
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
                                var locality = $(this).attr('locality');
                                $('#wizard .status').fadeOut(function() {
                                    self.showZoneAt(locality, lat, lng);
                                });
                                return false;
                            });
                        }
                    });
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
                    page: 'wizardZone',
                    feeds: self.feeds(zone)
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
                height: 300,
                opacity: 1,
                page: 'wizardSubscribe'
            };
            $.extend(opts, args.zone);
            self.show(opts, function() {
                $('#wizard .next').click(function(){
                    self.setHash(
                        args.area, args.zone, 'subscribe',
                        $('input[name=reminder-radio]:checked').val()
                    );
                    return false;
                });
            });
        },

        '!/:area/:zone/subscribe/:type': function(args) {
            var self = this;

            var opts = {
                height: 400,
                opacity: 1,
                page: 'wizardForm',
                type: args.type
            };
            $.extend(opts, args.zone);
            self.show(opts, function() {
                $('#wizard form').validate(self.validate[args.type])
                $('#wizard input[name=phone]').mask('999-999-9999');
                $('#wizard .next').click(function() {
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

    showZoneAt: function(locality, lat, lng) {
        var self = this;
        var zone = [ lat, lng ].join(',');
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

    // Build a hash of component types to their short name, like 
    //  {locality: 'Vancouver', country: 'CA', ...}
    addressComponent: function(component_type, result) {
        var value;
        $.each(result.address_components, function(i, component) {
            $.each(component.types, function(i, type) {
                if (type == component_type) value = component.short_name;
            });
        });
        return value;
    },

    restrictLocalities: function(results) {
        var self = this;

        var validCities = [
            {locality: 'Vancouver', country: 'CA'}
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

    adjustHeight: function() {
        var self = this;

        // position middle:
        $('#wizard .middle').each(function(i, node) {
            $(node).css({ marginTop: (0 - $(node).height() / 2) + 'px' });
        });
    },

    getZone: function(area, name, callback) {
        var self = this;
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
                console.log(data);
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
