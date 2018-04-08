import QtQuick 2.2
import QtQuick.XmlListModel 2.0

Item {
    property string filename: ""
    property alias cachelist: xlmCacheList
    property alias status: xlmCacheList.status
    property alias progress: xlmCacheList.progress

    XmlListModel {
        id: xlmCacheList

        source: filename
        query: "/gpx/wpt"
        namespaceDeclarations: "declare namespace groundspeak='http://www.groundspeak.com/cache/1/0/1'; declare default element namespace 'http://www.topografix.com/GPX/1/0';"

        /*
         * Get cache details
         */
        XmlRole { name: "lat"; query: "@lat/string()" }
        XmlRole { name: "lon"; query: "@lon/string()" }
        XmlRole { name: "name"; query: "name/string()" }
        XmlRole { name: "gsname"; query: "groundspeak:cache/groundspeak:name/string()" }
        XmlRole { name: "type"; query: "groundspeak:cache/groundspeak:type/string()" }
        XmlRole { name: "difficulty"; query: "groundspeak:cache/groundspeak:difficulty/string()" }
        XmlRole { name: "terrain"; query: "groundspeak:cache/groundspeak:terrain/string()" }
        XmlRole { name: "container"; query: "groundspeak:cache/groundspeak:container/string()" }
        XmlRole { name: "owner"; query: "groundspeak:cache/groundspeak:owner/string()" }
        XmlRole { name: "short_description"; query: "groundspeak:cache/groundspeak:short_description/string()" }
        XmlRole { name: "long_description"; query: "groundspeak:cache/groundspeak:long_description/string()" }

        //XmlRole { name: "last_found_log"; query: "groundspeak:cache/groundspeak:logs/groundspeak:log/groundspeak:type[matches(text(),'Found it')]/../groundspeak:date/text()" }
        XmlRole { name: "last_log"; query: "groundspeak:cache/groundspeak:logs/groundspeak:log[1]/groundspeak:date/string()" }
        //XmlRole { name: "last_found_log"; query: "groundspeak:cache/groundspeak:logs/groundspeak:log[1]/groundspeak:date/string()" }

        // Should add cache/travelbugs too -- need to find what's in there

        onStatusChanged: {
            // var componentCache;
            var newCache;

            console.debug("> cachelist.onStatusChanged: " + status);

            if (status === 2) {  /* XmlListModel.Loading */
            }

            if (status === 1) {  /* XmlListModel.Ready */
                for (var i = 0;i < cachelist.count; i++) {
                    var c = cachelist.get(i);

                    /* This seems to make the distance property a QJSValue rather than a QReal */
                    /* Which then causes an error when we try to display it as text in a Label */
                    // c.distance = Qt.binding(function() { return app.myPosition.coordinate.distanceTo(Qt.coordinate(c.lat,c.lon)); });
                    // newCache = new Cache(c);

                    // newCache.distance = Qt.binding(function() { return app.myPosition.coordinate.distanceTo(Qt.coordinate(c.lat,c.lon)); }));
                    // JsCreateCache.createCache(c);
                    // if (JsCreateCache.newCache != null) {
                    //newCache = JsCache.Cache(c);
                    app.caches.append(c);
                    // } else {
                    //     console.debug("PocketQuery.qml::onStateChanged() new cache is null");
                    // }

                    // app.caches.setProperty(app.caches.count - 1,"distance",Qt.binding(function() { return app.myPosition.coordinate.distanceTo(Qt.coordinate(c.lat,c.lon)); }));
                }
            }

            console.debug("< cachelist.onStatusChanged: " + status);
        }
    }
}
