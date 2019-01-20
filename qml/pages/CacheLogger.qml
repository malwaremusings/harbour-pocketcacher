import QtQuick 2.2
import Sailfish.Silica 1.0
import ".."

Dialog {
    id: dialogCacheLogger

    property var cache

    SilicaFlickable {
        anchors.fill: parent
        // anchors.leftMargin: Theme.horizontalPageMargin
        // anchors.rightMargin: Theme.horizontalPageMargin
        contentHeight: colCacheLogger.height

        Column {
            id: colCacheLogger

            width: parent.width

            // anchors.leftMargin: Theme.horizontalPageMargin
            // anchors.rightMargin: Theme.horizontalPageMargin

            DialogHeader {
                width: parent.width

                title: "Log Cache"
            }

            ComboBox {
                id: comboLogType

                label: "Log type"
                width: parent.width

                menu: ContextMenu {
                    MenuItem { text: "Found It" }
                    MenuItem { text: "Didn't Find It" }
                    MenuItem { text: "Write Note" }
                }
            }

            Grid {
                id: gridDateTime

                columns: 2
                rows: 2

                width: parent.width
                anchors.leftMargin: Theme.horizontalPageMargin
                anchors.rightMargin: Theme.horizontalPageMargin
                spacing: Theme.paddingMedium

                Label {
                    id: labelDate

                    width: parent.width / 2
                    text: pickerDate.dateText
                    horizontalAlignment: Text.AlignHCenter
                }

                Label {
                    id: labelTime

                    width: parent.width / 2
                    text: pickerTime.timeText
                    horizontalAlignment: Text.AlignHCenter
                }

                DatePicker {
                    id: pickerDate

                    width: parent.width / 2
                }

                TimePicker {
                    id: pickerTime

                    property var nowish: new Date();

                    width: parent.width / 2
                    hour: nowish.getHours()
                    minute: nowish.getMinutes()
                }
            }

            TextField {
                id: tfieldFinder

                width: parent.width
                placeholderText: "Your Geocaching name"
                label: "Username"
            }

            TextArea {
                id: tareaText

                width: parent.width
                focus: false
                placeholderText: "Share your story. Try not to leave any spoilers!"
                label: "Log entry"
            }
        }
    }

    onAccepted: {
        console.debug("> CacheLogger.qml::onAccepted()");
        /*
         * JS Date() apparently doesn't calculate TZ offset properly for local time, in that it applies the
         * current TZ offset regardless of whether DST was in effect at the specified time or not!
         * https://doc.qt.io/qt-5/qml-qtqml-date.html
         */

        var datetime = new Date(pickerDate.year,pickerDate.month - 1,pickerDate.day,pickerTime.hour,pickerTime.minute);
        var dateStr = datetime.toISOString().substring(0,10);
        var timeStr = datetime.toTimeString().substring(0,5);

        /* should check for a valid db object first */
        app.logbook.add({"name": cache.name,"timestamp": datetime.valueOf(),"date": dateStr,"time": timeStr,"type": comboLogType.value,"finder": tfieldFinder.text,"text": tareaText.text});
        // app.logbook.logentries.append({"name": cache.name,"timestamp": datetime.valueOf(),"date": d,"time": timestr,"type": type,"finder": finder,"text": text});
        console.debug("< CacheLogger.qml::onAccepted()");
    }
}
