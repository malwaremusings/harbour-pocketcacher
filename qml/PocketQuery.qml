import QtQuick 2.0
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

        // Should add cache/travelbugs too -- need to find what's in there
    }
}
