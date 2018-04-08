import QtQuick 2.2
import Sailfish.Silica 1.0

Page {

    property var logentry

    SilicaFlickable {
        anchors.fill: parent
        anchors.leftMargin: Theme.horizontalPageMargin
        anchors.rightMargin: Theme.horizontalPageMargin
        contentHeight: colLogBookEntry.height

        Column {
            id: colLogBookEntry

            width: parent.width

            PageHeader {
                title: logentry.date + " " + logentry.time
            }

            DetailItem {
                label: qsTr("Cache")
                value: logentry.name
            }

            DetailItem {
                label: qsTr("Type")
                value: logentry.type
            }

            DetailItem {
                label: qsTr("Finder")
                value: logentry.finder
            }

            Label {
                id: labelLogEntryText
                width: parent.width

                text: qsTr(logentry.text)
                horizontalAlignment: Text.AlignLeft
                wrapMode: Text.Wrap
            }
        }
    }
}
