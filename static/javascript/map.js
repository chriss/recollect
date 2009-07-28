(function($) {

TrashMap = function(opts) {
    if (!arguments.length) opts = {};
    $.extend(this, opts);
}

TrashMap.prototype = {
    center: [ 49.26422,-123.138542 ],

    getZoneInfo: function(name, color, callback) {
        $.getJSON('/zones/' + name + '/pickupdays.json', function (data) {
            var cal = new Calendar({ markColor: color });
            var table = cal.create();
            $.each(data, function(i,d) { cal.mark(d) });
            cal.show();

            callback(table);
        });
    },

    showSchedule: function(node, name, color) {
        var self = this;

        this.getZoneInfo(name, color, function(result) {
            if (!node) throw new Error("Node required");
            if (node.openInfoWindow) {
                node.openInfoWindow(result);
            }
            else {
                var center = node.getBounds().getCenter();
                self.map.openInfoWindow(center, result);
            }
        });
    },

    render: function(node) {
        var self = this;
        this.map = new GMap2(node);
        this.map.setCenter(
            new GLatLng(this.center[0], this.center[1]), 13
        );
        this.map.setUIToDefault();
        this.loadKML();
    },

    loadKML: function(url) {
        var self = this;
        this.zones = [];
        this.exml = new EGeoXml("exml", this.map, "zones.kml", {
            createpolygon: function (pts,sc,sw,so,fc,fo,pl,name) {
                var zone = new GPolygon(pts, sc, sw, so, fc, fo);
                GEvent.addListener(zone, 'click', function() {
                    self.showSchedule(zone, name, fc);
                    return false;
                });
                zone.name = name;
                self.zones.push(zone);
                self.map.addOverlay(zone);
            }
        });
        GEvent.addListener(this.exml, 'parsed', function() {
            self.setCurrentLocation();
        });
        this.exml.parse();
    },

   /* Google Map Custom Marker Maker 2009
    * Please include the following credit in your code
    *
    * Sample custom marker code created with Google Map Custom Marker Maker
    * http://www.powerhut.co.uk/googlemaps/custom_markers.php
    */
    createHomeIcon: function() {
        var myIcon = new GIcon();
        var myIcon = new GIcon();
        myIcon.image = '/images/homeIcon.png';
        myIcon.printImage = '/images/homeIconPrint.gif';
        myIcon.mozPrintImage = '/images/homeIconMozPrint.gif';
        myIcon.iconSize = new GSize(20,20);
        myIcon.shadow = '/images/homeIconShadow.png';
        myIcon.transparent = '/images/homeIconTransparent.png';
        myIcon.shadowSize = new GSize(30,20);
        myIcon.printShadow = '/images/homeIconPrintShadow.gif';
        myIcon.iconAnchor = new GPoint(10,20);
        myIcon.infoWindowAnchor = new GPoint(10,0);
        myIcon.imageMap = [15,0,15,1,15,2,15,3,15,4,16,5,17,6,18,7,19,8,19,9,16,10,16,11,16,12,16,13,16,14,16,15,16,16,16,17,16,18,3,18,3,17,3,16,3,15,3,14,3,13,3,12,3,11,3,10,0,9,0,8,1,7,2,6,3,5,5,4,6,3,7,2,8,1,9,0];
        return myIcon;
    },

    setCurrentLocation: function () {
        var self = this;
        if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(function(position) {
                if (self._location) return;
                self._location = new GLatLng(
                    position.coords.latitude, position.coords.longitude
                );
                var marker = new GMarker(self._location, {
                    icon: self.createHomeIcon()
                });
                self.map.addOverlay(marker);

                $.each(self.zones, function(i,zone) {
                    if (zone.Contains(self._location)) {
                        self.showSchedule(marker, zone.name, zone.color);
                        self._clicked_curloc = true;
                    }
                });
            });
        }
    },

    logClicks: function() {
        $('body').append(
            $('<a href="#">clear</a>')
                .click(function() { $('#clicks').empty() })
        );
        $('body').append('<div id="clicks"></div>');
        GEvent.addListener(this.map, 'click', function(o, latlng) {
            if (latlng) {
                $('#clicks').append(latlng.x+', '+latlng.y+', 0<br/>');
            }
        });
    }
}

})(jQuery);
