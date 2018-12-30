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
    // property int travelTime: Math.round((cache.navigateTime > 0 ? (Date.now() / 1000) - cache.navigateTime : -1) / 1000)
    property int travelTime: (cache.navigateStart > 0) ? ((cache.navigateEnd > 0) ? cache.navigateEnd : (Date.now() / 1000)) - cache.navigateStart : -1
    property int searchTime: (cache.searchStart > 0) ? ((cache.searchEnd > 0) ? cache.searchEnd : (Date.now() / 1000)) - cache.searchStart : -1
    property bool searching: (cache.searchStart > 0)

    SilicaFlickable {
        anchors.fill: parent
        height: colCacheNavigate.height
        contentHeight: colCacheNavigate.height
        anchors.leftMargin: Theme.horizontalPageMargin
        anchors.rightMargin: Theme.horizontalPageMargin

        PullDownMenu {
            MenuItem {
                text: qsTr("Log geocache")
                onClicked: {
                    cache.searchEnd = Date.now() / 1000;
                    pageStack.push(Qt.resolvedUrl("CacheLogger.qml"),{ cache: cache });
                }
            }
        }

        Column {
            id:colCacheNavigate

            width: parent.width

            PageHeader {
                title: qsTr(cache.gsname)
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

                label: qsTr("Owner")
                value: qsTr(cache.owner)
                // horizontalAlignment: Text.AlignLeft
                // truncationMode: TruncationMode.Fade
                // wrapMode: Text.Wrap
            }

            DetailItem {
                width: parent.width

                label: qsTr("Last found")
                value: (cache.lastFound) ? qsTr(cache.lastFound) : "[unknown]"
                // horizontalAlignment: Text.AlignLeft
                // wrapMode: Text.Wrap
            }

            SectionHeader {
                text: qsTr("Navigation")
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

                text: Math.round(distance) + qsTr(" metre(s)")
                font.pixelSize: Theme.fontSizeHuge
            }

            SectionHeader {
                text: qsTr("Positioning")
            }

            DetailItem {
                label: qsTr("Horizontal accuracy")
                value: app.myPosition.horizontalAccuracy
            }

            SectionHeader {
                text: qsTr("Timers")
            }

            DetailItem {
                label: qsTr("Travel time")
                //value: ((navigateEnd === 0) ? (Date.now() / 1000) : navigateEnd) - navigateStart
                value: travelTime
                visible: travelTime >= 0
            }

            DetailItem {
                label: qsTr("Search time")
                value: searchTime
                visible: searchTime >= 0
            }

            SectionHeader {
                text: qsTr("Options")
            }

            TextSwitch {
                id: txtswNavSound

                text: qsTr("Navigation sound")
                description: qsTr("Sound to indicate distance and bearing to cache")
                checked: false
            }
        }
    }

    Component.onCompleted: {
        if (cache.navigateStart === 0) cache.navigateStart = (Date.now() / 1000);
        console.debug("NavigatePage: NavigateTime is " + cache.navigateStart);
    }

    /*
     * i think this needs tidying up and possibly moving elsewhere
     */
    Timer {
        interval: 1000
        running: true
        triggeredOnStart: true
        repeat: true
        onTriggered: {
            /* if within 10 metres, switch from travel state to search state */
            var d = Date.now() / 1000;
            if (!searching && distance >= 0 && distance < 10) {
                cache.navigateEnd = d;
                cache.searchStart = d;
                searching = true;
            }

            if (!searching) {
                travelTime = ((cache.navigateEnd > 0) ? cache.navigateEnd : (Date.now() / 1000)) - cache.navigateStart;
            } else {
                searchTime = ((cache.searchEnd > 0) ? cache.searchEnd : (Date.now() / 1000)) - cache.searchStart;
            }

            //console.debug("CacheNavigate Timer: Setting travelTime to " + travelTime);
        }
    }

    Timer {
        id: timerDistance

        // interval: (Math.trunc(distance / 100) + 1) * 1000
        interval: (distance >= Math.E) ? (Math.log(distance) * 100) : 100
        running: txtswNavSound.checked
        triggeredOnStart: true
        repeat: true
        onTriggered: {
            console.debug("[D] timerDistance interval: " + interval);
            /* Drop an octave over 180 degrees by dropping 1.2222222 Hz / degree */
            //app.beeper.setFrequency(440 - ((Math.abs(heading) / 180) * 1.22222222));

            /* 12 semitones to an octave                        */
            /* (180 / 12) == 15 degrees to a semitone           */
            /* Drop a semitone for every 15 degrees off course  */
            /* will drop an octave over 180 degrees             */
            /* This may be easier to hear than the above method */
            app.beeper.setNote(-Math.round(Math.abs(heading) / 15));
            app.beeper.beep();
        }
    }
}
