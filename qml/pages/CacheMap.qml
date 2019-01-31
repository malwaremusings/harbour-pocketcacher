import QtQuick 2.2
import Sailfish.Silica 1.0
import QtPositioning 5.3
import QtLocation 5.0

Page {
    property var mapCentre
    backNavigation: false

    Plugin {
        id: mapPlugin

        name: "osm"     // "mapboxgl", "esri", ...
    }

    Component.onCompleted: {
        mapCentre = app.myPosition.coordinate;
        // mapCache.zoomLevel = mapCache.maximumZoomLevel;
    }

    Column {
        anchors.fill: parent
        // anchors.top: parent.top
        // anchors.bottom: parent.bottom
        // anchors.horizontalCenter: parent.horizontalCenter
        // width: parent.width

        Map {
            id: mapCache

            width: parent.width
            height: parent.height - rowButtonBar.height
            anchors.horizontalCenter: parent.horizontalCenter
            // anchors.fill: parent
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

        Row {
            id: rowButtonBar

            Rectangle {
                // anchors.bottom: mapCache.bottom
                // anchors.left: mapCache.left
                color: Theme.highlightBackgroundColor
                width: buttonBack.width
                height: buttonBack.height

                Button {
                    id: buttonBack
                    anchors.fill: parent

                    text: qsTr("Back")

                    onClicked: {
                        pageStack.pop();
                    }
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
                                pageStack.push(Qt.resolvedUrl("CacheDetails.qml"),{ cache: miv.model.getCache(index) });
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
                                pageStack.push(Qt.resolvedUrl("CacheDetails.qml"),{ cache: miv.model.getCache(index) });
                            }
                        }
                    }
                }
            }
        }
    }
}
