import QtQuick 2.0
import Sailfish.Silica 1.0
import QtPositioning 5.3

Page {
    property var cache
    property var cachecoords: QtPositioning.coordinate(cache.lat,cache.lon)
    property var hereiam: app.myPosition.coordinate
    property var distance: hereiam.distanceTo(cachecoords)
    property var bearing: hereiam.azimuthTo(cachecoords)

    SilicaFlickable {
        anchors.fill: parent

        PullDownMenu {
            MenuItem {
                text: qsTr("Log")
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("CacheLogger.qml"),{ cache: cache });
                }
            }

            MenuItem {
                text: qsTr("Navigate to")
                onClicked: {
                    console.debug("CacheDetails.qml 'Navigate to' menu: " + cache.name + " (" + distance + "/" + bearing + ")");
                    // pageStack.push(Qt.resolvedUrl("CacheNavigate.qml"),{ cache: cache, distance: distance, bearing: bearing });
                    pageStack.push(Qt.resolvedUrl("CacheNavigate.qml"),{ cache: cache });
                }
            }
        }

        Column {
            anchors.fill: parent
            anchors.leftMargin: Theme.horizontalPageMargin
            anchors.rightMargin: Theme.horizontalPageMargin

            PageHeader {
                title: cache.gsname
            }

            SectionHeader {
                text: "Details"
            }

            Row {
                width: parent.width

                Label {
                    width: parent.width / 2

                    text: qsTr(cache.name)
                    horizontalAlignment: Text.AlignLeft
                    /* Setting truncationMode on these labels seems to cause */
                    /* QML binding loop!                                     */
                    // truncationMode: TruncationMode.Fade
                    wrapMode: Text.Wrap
                }

                Label {
                    width: parent.width / 2

                    text: qsTr(cache.type)
                    horizontalAlignment: Text.AlignRight
                    // truncationMode: TruncationMode.Fade
                    wrapMode: Text.Wrap
                }
            }

            Row {
                width: parent.width

                Label {
                    width: parent.width / 2

                    text: qsTr(cache.container)
                    horizontalAlignment: Text.AlignLeft
                    // truncationMode: TruncationMode.Fade
                    wrapMode: Text.Wrap
                }

                Label {
                    width: parent.width / 2

                    text: cache.difficulty + "/" + cache.terrain
                    horizontalAlignment: Text.AlignRight
                }
            }

            Label {
                width: parent.width

                text: qsTr(cache.owner)
                // truncationMode: TruncationMode.Fade
                wrapMode: Text.Wrap
            }

            Row {
                width: parent.width

                Label {
                    width: parent.width / 2

                    text: Math.round(distance) + " m"
                    horizontalAlignment: Text.AlignLeft
                }

                Label {
                    width: parent.width / 2

                    text: Math.round(bearing) + " deg"
                    horizontalAlignment: Text.AlignRight
                }
            }

            SectionHeader {
                text: qsTr("Summary")
            }

            Label {
                width: parent.width

                text: qsTr(cache.short_description)
                horizontalAlignment: Text.AlignLeft
                // truncationMode: TruncationMode.Fade
                wrapMode: Text.Wrap
            }

            SectionHeader {
                text: "Description"
            }

            Label {
                width: parent.width

                text: qsTr(cache.long_description)
                horizontalAlignment: Text.AlignLeft
                // truncationMode: TruncationMode.Fade
                wrapMode: Text.Wrap
            }
        }
    }
}
