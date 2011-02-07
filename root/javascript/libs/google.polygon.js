// From http://code.google.com/p/google-maps-extensions/

polygonGetBounds = function(polygon) {
    var bounds = new google.maps.LatLngBounds();
    var paths = polygon.getPaths();
    var path;
    for (var p = 0; p < paths.getLength(); p++) {
        path = paths.getAt(p);
        for (var i = 0; i < path.getLength(); i++) {
            bounds.extend(path.getAt(i));
        }
    }
    return bounds;
}

function polygonContains (polygon, latLng) {
    // Outside the bounds means outside the polygon
    if (!polygonGetBounds(polygon).contains(latLng)) {
        return false;
    }

    var lat = latLng.lat();
    var lng = latLng.lng();
    var paths = polygon.getPaths();
    var path, pathLength, inPath, i, j, vertex1, vertex2;

    // Walk all the paths
    for (var p = 0; p < paths.getLength(); p++) {

        path = paths.getAt(p);
        pathLength = path.getLength();
        j = pathLength - 1;
        inPath = false;

        for (i = 0; i < pathLength; i++) {

            vertex1 = path.getAt(i);
            vertex2 = path.getAt(j);

            if (vertex1.lng() < lng && vertex2.lng() >= lng || vertex2.lng() < lng && vertex1.lng() >= lng) {
                if (vertex1.lat() + (lng - vertex1.lng()) / (vertex2.lng() - vertex1.lng()) * (vertex2.lat() - vertex1.lat()) < lat) {
                    inPath = !inPath;
                }
            }

            j = i;

        }

        if (inPath) {
            return true;
        }

    }

    return false;
}
