import QtQuick 2.2
import Sailfish.Silica 1.0
import QtPositioning 5.3
import "../harbour-pocketcacher.js" as JSPocketCacher


Page {
    property var cache
    property var cachecoords: QtPositioning.coordinate(cache.lat,cache.lon)
    property var hereiam: app.myPosition.coordinate
    property real distance: hereiam.distanceTo(cachecoords)
    property real bearing: hereiam.azimuthTo(cachecoords)

    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.All

    SilicaFlickable {
        // anchors {
        //     top:header.bottom
        //     bottom: parent.bottom
        //     left: parent.left
        //     right: parent.right
        // }

        anchors.fill: parent
        contentHeight: colCacheDetails.height

        PullDownMenu {
            MenuItem {
                text: qsTr("Log geocache")
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
            id: colCacheDetails

            // anchors.leftMargin: Theme.horizontalPageMargin
            // anchors.rightMargin: Theme.horizontalPageMargin
            // anchors.fill: parent
            width: parent.width

            PageHeader {
                id: header

                title: cache.gsname
            }

            SectionHeader {
                text: "Details"
            }

            Row {
                // anchors.leftMargin: Theme.horizontalPageMargin
                // anchors.rightMargin: Theme.horizontalPageMargin
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
                // anchors.leftMargin: Theme.horizontalPageMargin
                // anchors.rightMargin: Theme.horizontalPageMargin
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
                // anchors.leftMargin: Theme.horizontalPageMargin
                // anchors.rightMargin: Theme.horizontalPageMargin
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
                //textFormat: Text.PlainText
                horizontalAlignment: Text.AlignLeft
                // truncationMode: TruncationMode.Fade
                wrapMode: Text.Wrap
            }

            SectionHeader {
                text: qsTr("Description")
            }

            Label {
                width: parent.width

                text: qsTr(cache.long_description)
                //textFormat: Text.PlainText
                horizontalAlignment: Text.AlignLeft
                // truncationMode: TruncationMode.Fade
                wrapMode: Text.Wrap
            }

            SectionHeader {
                text: qsTr("Hint")

                visible: cache.encoded_hints !== ""
            }

            TextSwitch {
                id: txtswRevealHint

                text: qsTr("Decode hint")
                checked: false
                visible: cache.encoded_hints !== ""
            }

            Label {
                width: parent.width

                text: txtswRevealHint.checked ? qsTr(cache.encoded_hints) : qsTr(JSPocketCacher.rot13(cache.encoded_hints))
                horizontalAlignment: Text.AlignLeft
                wrapMode: Text.Wrap
                visible: cache.encoded_hints !== ""
            }

        }

        VerticalScrollDecorator { }

    }
}
