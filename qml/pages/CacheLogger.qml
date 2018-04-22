import QtQuick 2.2
import Sailfish.Silica 1.0
import ".."

Dialog {
    id: dialogCacheLogger

    property var cache
    property int date
    property alias type: comboLogType.value
    property alias finder: tfieldFinder.text
    property alias text: tareaText.text

    SilicaFlickable {
        anchors.fill: parent
        anchors.leftMargin: Theme.horizontalPageMargin
        anchors.rightMargin: Theme.horizontalPageMargin
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

            Row {
                id: rowDateTime

                width: parent.width
                spacing: Theme.paddingMedium
                property date currentTime: new Date()

                Button {
                    id: buttonDate

                    property int day: rowDateTime.currentTime.getDate()
                    property int month: rowDateTime.currentTime.getMonth()
                    property int year: rowDateTime.currentTime.getYear()

                    width: Theme.buttonWidthSmall

                    text: qsTr((rowDateTime.currentTime.getYear() + 1900) + "-" + ("0" + (rowDateTime.currentTime.getMonth() + 1)).substr(-2) + "-" + ("0" + rowDateTime.currentTime.getDate()).substr(-2))

                    onClicked: {
                        var dialog = pageStack.push(pickerDate,{ date: rowDateTime.currentTime });

                        dialog.accepted.connect(function() {
                            buttonDate.text = qsTr(dialog.dateText);
                            buttonDate.day = dialog.day;
                            buttonDate.month = dialog.month;
                            buttonDate.year = dialog.year;
                        });
                    }

                    Component {
                        id: pickerDate

                        DatePickerDialog { }
                    }
                }

                Button {
                    id: buttonTime

                    property int hour: rowDateTime.currentTime.getHours()
                    property int minute: rowDateTime.currentTime.getMinutes()

                    width: Theme.buttonWidthSmall
                    text: qsTr(rowDateTime.currentTime.getHours() + ":" + rowDateTime.currentTime.getMinutes())

                    onClicked: {
                        var dialog = pageStack.push(pickerTime,{
                                                        hour: rowDateTime.currentTime.getHours(),
                                                        minute: rowDateTime.currentTime.getMinutes(),
                                                        hourMode: DateTime.TwentyFourHours
                                                    });

                        dialog.accepted.connect(function() {
                            buttonTime.text = qsTr(dialog.timeText);
                            buttonTime.hour = dialog.hour;
                            buttonTime.minute = dialog.minute;
                        });
                    }

                    Component {
                        id: pickerTime

                        TimePickerDialog { }
                    }
                }
            }

            TextField {
                id: tfieldFinder

                width: parent.width
                placeholderText: "Your Geocaching name -- currently unused"
                label: "Username"
            }

            TextArea {
                id: tareaText

                width: parent.width
                focus: true
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

        var datetime = new Date(buttonDate.year,buttonDate.month,buttonDate.day,buttonTime.hour,buttonTime.minute);
        var d = (buttonDate.year + 1900) + "-" + ("0" + (buttonDate.month + 1)).substr(-2) + "-" + ("0" + buttonDate.day).substr(-2);

        /* should check for a valid db object first */
        app.logbook.add({"name": cache.name,"timestamp": datetime.valueOf(),"date": d,"time": buttonTime.text,"type": type,"finder": finder,"text": text});
        // app.logbook.logentries.append({"name": cache.name,"timestamp": datetime.valueOf(),"date": d,"time": timestr,"type": type,"finder": finder,"text": text});
        console.debug("< CacheLogger.qml::onAccepted()");
    }
}
