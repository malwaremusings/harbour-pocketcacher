import QtQuick 2.2
import Sailfish.Silica 1.0
import QtPositioning 5.3

Page {
    id: pageCacheNavigate

    property var cache
    property var cachecoords: QtPositioning.coordinate(cache.lat,cache.lon)
    property var hereiam: app.myPosition.coordinate
    property double distance: hereiam.distanceTo(cachecoords)
    property double bearing: hereiam.azimuthTo(cachecoords)
    property real heading: bearing - app.myDirection

    SilicaFlickable {
        anchors.fill: parent

        Column {
            anchors.fill: parent
            width: parent.width
            anchors.leftMargin: Theme.horizontalPageMargin
            anchors.rightMargin: Theme.horizontalPageMargin

            PageHeader {
                title: qsTr(cache.name)
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

            DetailItem {
                width: parent.width

                label: "Owner"
                value: qsTr(cache.owner)
                // horizontalAlignment: Text.AlignLeft
                // truncationMode: TruncationMode.Fade
                // wrapMode: Text.Wrap
            }

            DetailItem {
                width: parent.width

                label: "Last log"
                //value: qsTr(cache.last_found_log)
                value: qsTr(cache.last_log)
                // horizontalAlignment: Text.AlignLeft
                // wrapMode: Text.Wrap
            }

            SectionHeader {
                text: "Navigation"
             }

            /*
             * Time to bring in the glossy white arrow
             * (from https://openclipart.org/detail/168037/glossy-white-arrow)
             */
            Image {
                anchors.horizontalCenter: parent.horizontalCenter

                source: "pics/glossy-white-arrow.svg"
                horizontalAlignment: Image.AlignHCenter
                verticalAlignment: Image.AlignVCenter
                rotation: heading
            }

            Label {
                anchors.horizontalCenter: parent.horizontalCenter

                text: Math.round(distance) + " metre(s)"
                font.pixelSize: Theme.fontSizeHuge
            }

            SectionHeader {
                text: "Positioning"
            }

            DetailItem {
                label: "Horizontal accuracy"
                value: app.myPosition.horizontalAccuracy
            }
        }
    }
}
