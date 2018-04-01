import QtQuick 2.0
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

            /*
             * Time to bring in the glossy white arrow from:
             * https://openclipart.org/detail/168037/glossy-white-arrow
             */
            Image {
                source: "pics/glossy-white-arrow.svg"
                horizontalAlignment: Image.AlignHCenter
                verticalAlignment: Image.AlignVCenter
                rotation: heading
            }

            Label {
                width: parent.width

                text: Math.round(distance) + " metre(s)"
                font.pixelSize: Theme.fontSizeHuge
                horizontalAlignment: Text.AlignLeft
            }

        }
    }
}
