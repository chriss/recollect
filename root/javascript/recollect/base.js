(function($) {

Recollect  = function() {
};

Recollect.prototype = {
    start: function() {
        var self = this;
        History.Adapter.bind(window, 'statechange', function() {
            var state = History.getState();

            var parts = state.url.replace(
                new RegExp('.+' + location.host), ''
            ).split('/');

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
        });

        // Grab initial state
        if (!History.getState()) {
            self.setLocation(location.pathname);
        }
    },

    setLocation: function() {
        var state = $.makeArray(arguments).join('/');
        History.pushState(null, null, state);
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
