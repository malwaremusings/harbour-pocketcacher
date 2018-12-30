import QtQuick 2.2
import QtPositioning 5.3

Item {
    id: cacheModel

    property alias caches: lstCaches
    property alias cachesFound: lstCachesFound
    property var   allcaches: []
    property bool  sorted: false;

    ListModel {
        id: lstCaches
    }

    ListModel {
        id: lstCachesFound
    }

    /*
     * i don't like this -- it should be done with a binding, but i can't
     * figure out how to make a binding that works
     */
    function refresh_distances() {
        for (var i = 0;i < allcaches.length;i++) {
            var c = allcaches[i];
            var d = app.myPosition.coordinate.isValid ? Math.round(app.myPosition.coordinate.distanceTo(QtPositioning.coordinate(c.lat,c.lon))) : -1;

            /* don't like this -- the latter should be bound to the former */
            /* but i can't get Qt.binding() to work */
            c.distance = d;
            lstCaches.setProperty(i,"distance",d);
        }

        /*
         * Don't really like this here
         * Should be in an on...Changed() signal handler, but that doesn't
         * seem to get called
         */
        if (allcaches.length > 0 && app.myPosition.coordinate.isValid && !sorted) {
            console.debug("Performing initial sort");
            refresh();
            sorted = true;
        }
    }

    function refresh() {
        lstCaches.clear();

        allcaches.sort(function (a,b) {
            return a.distance - b.distance;
        });
        for (var i = 0;i < allcaches.length;i++) {
            lstCaches.append(allcaches[i]);
        }
    }

    onAllcachesChanged: function (i,j,k) {
        console.debug("CacheModel.qml::onAllcachesChanged(" + i + "," + j + "," + k + ")");
    }
}
