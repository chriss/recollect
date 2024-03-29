(function($) {

Recollect  = function() {
};

Recollect.prototype = {
    start: function() {
        var self = this;

        // Grab initial state
        self.showState();
        var current = location.pathname;
        $(window).bind('popstate', function() {
            if (current != location.pathname) {
                self.showState();
                current = location.pathname;
            }
        });
    },

    showState: function() {
        var self = this;

        var parts = location.pathname.split('/');

        var found_url = false;

        $.each(self.pages, function(test, callback) {
            var test_parts = test.split('/');

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
                    found_url = true;
                    self.trackPageview(test);
                    callback.call(self, args);
                    return false; // early out
                }
            }
        });

        if (!found_url) {
            self.setLocation('/');
        }
    },

    setLocation: function() {
        var state = $.makeArray(arguments).join('/');
        if ($.isFunction(history.pushState)) {
            history.pushState(null, null, state);
            this.showState();
        }
        else {
            location = state;
        }
    },

    pages: {},

    /* Google Analytics */
    trackEvent: function(action, label) {
        if ($.isArray(label)) label = label.join(', ');
        if (typeof(_gaq) != 'undefined') _gaq.push(['_trackEvent', 'wizard', action, label]);
    },

    trackPageview: function(url) {
        if (typeof(_gaq) != 'undefined') _gaq.push(['_trackPageview', url]);
    }
};

})(jQuery);
