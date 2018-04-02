import QtQuick 2.0
import Sailfish.Silica 1.0

Dialog {
    id: dialogCacheLogger

    property var cache
    property date date
    property alias type: comboLogType.value
    property alias finder: tfieldFinder.text
    property alias text: tareaText.text

    SilicaFlickable {
        anchors.fill: parent

        Column {
            anchors.fill: parent
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
                anchors.leftMargin: Theme.horizontalPageMargin
                anchors.rightMargin: Theme.horizontalPageMargin

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
                anchors.leftMargin: Theme.horizontalPageMargin
                anchors.rightMargin: Theme.horizontalPageMargin
                property date currentTime: new Date()

                Button {
                    id: buttonDate
                    width: Theme.buttonWidthSmall
                    text: qsTr("Select date")

                    onClicked: {
                        var dialog = pageStack.push(pickerDate,{ date: rowDateTime.currentTime });

                        dialog.accepted.connect(function() {
                            buttonDate.text = dialog.dateText;
                        });
                    }

                    Component {
                        id: pickerDate

                        DatePickerDialog { }
                    }
                }

                Button {
                    id: buttonTime
                    width: Theme.buttonWidthSmall
                    text: qsTr("Select time")

                    onClicked: {
                        var dialog = pageStack.push(pickerTime,{
                                                        hour: rowDateTime.currentTime.getHours(),
                                                        minute: rowDateTime.currentTime.getMinutes(),
                                                        hourMode: DateTime.TwentyFourHours
                                                    });

                        dialog.accepted.connect(function() {
                            buttonTime.text = dialog.timeText;
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
        /*
         * Ideally, I want 'date' to be seconds since epoch, but it is proving too hard for the moment
         * The 'new Date()' construct interprets the time as GMT (despite what the doco says) if TZ
         * offset isn't specified. I can't figure out how to find the TZ offset from the system.
         * When creating a Date(), it interprets the time as GMT, despite getTimezoneOffset() returning
         * a non-zero timezone offset after setting the time!
         * Also JS Date() apparently doesn't calculate TZ offset properly for local time, in that it applies the
         * current TZ offset regardless of whether DST was in effect at the specified time or not!
         * https://doc.qt.io/qt-5/qml-qtqml-date.html
         */

        // date = new Date(buttonDate.text + " " + buttonTime.text + "+1000");
        date = buttonDate.text + " " + buttonTime.text;

        app.db.transaction(function(tx) {
            try {
                console.debug("Inserting in to database");
                tx.executeSql("INSERT INTO CacheLogger VALUES (?,?,?,?,?)",[cache.name,date,type,finder,text]);
                console.debug("Done inserting");
            } catch (e) {
                console.debug("exception inserting in to databae" + e);
            }
        });
    }
}
