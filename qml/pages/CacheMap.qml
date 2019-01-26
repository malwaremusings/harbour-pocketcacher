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

            /* show my position */
            MapQuickItem {
                id: cacherPosition

                coordinate: app.myPosition.coordinate
                anchorPoint.x: Theme.iconSizeExtraSmall * 0.5
                anchorPoint.y: Theme.iconSizeExtraSmall * 0.5

                sourceItem: Rectangle {
                    color: "red"
                    width: Theme.iconSizeSmall * 0.5
                    height: Theme.iconSizeSmall * 0.5
                    radius: Theme.iconSizeSmall
                }
            }
        }

        Component {
            id: mapItemCache

            MapQuickItem {
                coordinate: QtPositioning.coordinate(lat,lon)

                anchorPoint.x: rectCache.width * 0.5
                anchorPoint.y: rectCache.height * 0.5

                sourceItem: Column {
                    Rectangle {
                        id: rectCache

                        width: Theme.iconSizeSmall * 0.5
                        height: Theme.iconSizeSmall * 0.5
                        radius: Theme.iconSizeSmall
                        border.width: 3
                        color: colour

                        MouseArea {
                            anchors.fill: parent

                            onClicked: {
                                console.debug("Map click on " + name);
                            }
                        }
                    }

                    Text {
                        text: name
                        anchors.horizontalCenter: rectCache.horizontalCenter

                        MouseArea {
                            anchors.fill: parent

                            onClicked: {
                                console.debug("Map click on " + name);
                            }
                        }
                    }
                }
            }
        }
    }
}
