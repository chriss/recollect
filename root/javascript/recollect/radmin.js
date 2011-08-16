(function($) {

if (typeof(Recollect) == 'undefined') Recollect = {};

Recollect.RADmin  = function(opts) {
    $.extend(this, this._defaults, opts);
}

Recollect.RADmin.prototype = new Recollect;
$.extend(Recollect.RADmin.prototype, {
    _defaults: {
    },

    start: function() {
        var self = this;
        $('.radminHome').click(function() {
            self.setLocation('/radmin');
            return false;
        });
        Recollect.prototype.start.call(self);
        self.render('#radmin .leftNav', 'radmin_leftnav', {
            areas: self.areas,
        });
    },

    pages: {
        '/radmin': function() {
            this.setNav();
            this.render('#radmin .content', 'radmin_home')
            this.showRecentReminders();
            this.plotRemindersByArea();
        },

        '/radmin/:area': function(args) {
            this.setNav(decodeURIComponent(args.area));
            this.render('#radmin .content', 'radmin_home')
            this.plotRemindersByArea(args.area);
        }
    },

    render: function(selector, page, opts) {
        var self = this;
        var $node = $(selector);
        $node.html(
            Jemplate.process(page, $.extend({}, {
            }, opts))
        );
        $node.find('.historyLink').click(function() {
            var url = $.map($(this).attr('href').split('/'), function(p) {
                return encodeURIComponent(p);
            }).join('/');
            self.setLocation(url);
            return false;
        });
    },

    setNav: function() {
        $('.customNav').html(
            Jemplate.process('radmin_nav', {
                elements: arguments
            })
        );
    },

    showRecentReminders: function() {
        var self = this;

        // XXX  come up with bette names than datatable and listtable
        $.getJSON('/radmin/data/object_stats', function(data) {
            $('#stats').html(
                Jemplate.process('dataTable', { data: data.table_size })
            );
        });

        $.getJSON('/radmin/data/recent_subscriptions', function(rows) {
            $('#recentSubscriptions').html(
                Jemplate.process('listTable', {
                    rows: rows,
                    columns: [
                        { field: 'target', display: 'Target' },
                        { field: 'created_at', display: 'Created At' },
                        { field: 'last_notified', display: 'Last Notified' },
                        { field: 'delivery_offset', display: 'Delivery Offset' }
                    ]
                })
            );
        });

        $.getJSON('/radmin/data/needs_pickups', function(rows) {
            $('#needsPickups').html(
                Jemplate.process('listTable', {
                    rows: rows,
                    columns: [
                        {
                            field: 'title',
                            display: 'Zone'
                        },
                        {
                            format: function(r) {
                                return r.lastpickup.day;
                            },
                            display: 'Last Pickup'
                        }
                    ]
                })
            );
        });

        $('#interestMap').html(Jemplate.process('interest_map'));

        var map = new google.maps.Map($('#interestMap .map').get(0), {
            zoom: 1,
            center: new google.maps.LatLng(0,0),
            mapTypeId: google.maps.MapTypeId.ROADMAP,
            disableDefaultUI: true
        });
        this.showInterestMarkers(map);
    },

    showInterestMarkers: function(map) {
        $.getJSON('/radmin/data/place_interest', function(places){
            $.each(places, function(_,place) {
                new google.maps.Marker({
                    map: map,
                    draggable: false,
                    icon: 'http://labs.google.com/ridefinder/images/mm_20_green.png',
                    title: place.at,
                    position: new google.maps.LatLng(place.lat, place.lon)
                });
            });
        });
    },

    plotRemindersByArea: function(area) {
        var url = area
            ? '/api/report/reminders_in_area/' + area
            : '/api/report/reminders_by_area';

        this.plot($('#subscriptionsByArea'), url, {
            series: {
                pie: { 
                    show: true,
                    radius: 1,
                    label: {
                        show: true,
                        radius: 3/4,
                        formatter: function(label, series){
                            return '<div style="font-size:8pt;text-align:center;padding:2px;color:white;">'+label+'<br/>'+Math.round(series.percent)+'%</div>';
                        },
                        background: { 
                            opacity: 0.5,
                            color: '#000'
                        }
                    }
                }
            }
        });
    },

    plot: function($node, url, opts) {
        $.getJSON(url, function(data) {
            $.plot($node, data, opts);
        });
    }
});

})(jQuery);
