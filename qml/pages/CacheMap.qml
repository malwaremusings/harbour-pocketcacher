import QtQuick 2.2
import Sailfish.Silica 1.0
import QtPositioning 5.3
import QtLocation 5.0

Page {
    property var mapCentre

    Plugin {
        id: mapPlugin

        name: "osm"     // "mapboxgl", "esri", ...
    }

    Component.onCompleted: {
        mapCentre = app.myPosition.coordinate;
        // mapCache.zoomLevel = mapCache.maximumZoomLevel;
    }

    SilicaFlickable {
        anchors.fill: parent

        Map {
            id: mapCache

            anchors.fill: parent
            /* This looks a bit daft! */
            // anchors.leftMargin: Theme.horizontalPageMargin
            // anchors.rightMargin: Theme.horizontalPageMargin

            plugin: mapPlugin

            center: mapCentre
            zoomLevel: maximumZoomLevel

            gesture.enabled: true

            MapItemView {
                id: miv

                model: app.caches
                delegate: mapItemCache
            }
        }

        Component {
            id: mapItemCache

            MapCircle {
                center: QtPositioning.coordinate(lat,lon)
                radius: 10
                border.width: 3
                color: 'red'

                MouseArea {
                    anchors.fill: parent

                    onClicked: console.debug("Map click on " + name);
                }
            }
        }
    }
}
