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
            //this.plotRemindersByArea();
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
        $.getJSON('/radmin/data/recent_subscriptions', function(rows) {
            $('#recentSubscriptions').html(
                Jemplate.process('dataTable', {
                    title: 'Recent Subscriptions',
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
            console.log(rows);
            $('#needsPickups').html(
                Jemplate.process('dataTable', {
                    title: 'Soon to run out of data',
                    rows: rows,
                    columns: [
                        {
                            field: 'title',
                            display: 'Zone'
                        },
                        {
                            format: function(r) {
                                return r.nextpickup.day;
                            },
                            display: 'Next Pickup'
                        }
                    ]
                })
            );
        });
    },

    plotRemindersByArea: function(area) {
        var url = area
            ? '/api/report/reminders_in_area/' + area
            : '/api/report/reminders_by_area';

        this.plot($('#subscriptions_by_area'), url, {
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
