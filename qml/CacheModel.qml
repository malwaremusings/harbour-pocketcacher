import QtQuick 2.2
import QtPositioning 5.3

Item {
    property alias caches: lstCaches
    property alias cachesFound: lstCachesFound

    ListModel {
        id: lstCaches

        onRowsInserted: function (s,e,i) {
            var c = lstCaches.get(i);
            lstCaches.setProperty(i,"distance",app.myPosition.coordinate.isValid ? Math.round(app.myPosition.coordinate.distanceTo(QtPositioning.coordinate(c.lat,c.lon))) : -1);
        }
    }

    ListModel {
        id: lstCachesFound
    }

    /*
     * i don't like this -- it should be done with a binding, but i can't
     * figure out how to make a binding that works
     */
    function refresh_distances() {
        for (var i = 0;i < lstCaches.count;i++) {
            var c = lstCaches.get(i);
            lstCaches.setProperty(i,"distance",app.myPosition.coordinate.isValid ? Math.round(app.myPosition.coordinate.distanceTo(QtPositioning.coordinate(c.lat,c.lon))) : -1);
        }
    }
}
