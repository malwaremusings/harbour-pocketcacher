import QtQuick 2.2
import Sailfish.Silica 1.0
import ".."

Page {

    SilicaFlickable {
        anchors.fill: parent

        PullDownMenu {
            MenuItem {
                text: qsTr("Export")
                onClicked: {
                    var dialog = pageStack.push(Qt.resolvedUrl("SaveFileDialog.qml"),{ filename: "logbook.txt" });
                    dialog.accepted.connect(function() {
                        var filename = dialog.filename;
                        console.debug("Save file dialog: " + filename);
                    });
                }
            }
        }

        SilicaListView {
            id: slvLogBook

            anchors.fill: parent
            anchors.leftMargin: Theme.horizontalPageMargin
            anchors.rightMargin: Theme.horizontalPageMargin

            header: PageHeader {
                title: qsTr("Log Book")
            }

            model: app.logbook.logentries

            section.property: "date"
            section.criteria: ViewSection.FullString
            section.delegate: SectionHeader {
                    // width: parent.width
                    // height: childrenRect.height
                    text: section
            }

            VerticalScrollDecorator {}

            ViewPlaceholder {
                text: qsTr("No logbook entries")
                hintText: qsTr("Select 'Log geocache' from cache page")
                enabled: app.logbook.logentries.count === 0
            }

            delegate: ListItem {
                id: loglistentry

                width: parent.width
                menu: Component {
                    ContextMenu {
                        MenuItem {
                            text: "Delete"
                            onClicked: {
                                console.debug("Logbook context menu (delete): " + index);

                                /*
                                 * should use a remorse timer, but seem to be having scoping issues
                                 * as i can't figure out how to access the 'del' method from within
                                 * the callback
                                 */
                                // loglistentry.remorseAction(qsTr("Deleting"),function() { app.logbook.del(index); });
                                app.logbook.del(index);
                            }
                        }
                    }
                }

                Row {
                    width: parent.width
                    height: childrenRect.height

                    Label {
                        width: parent.width / 3
                        color: loglistentry.highlighted ? Theme.highlightColor : Theme.primaryColor
                        text: time
                    }

                    Label {
                        width: parent.width / 3
                        color: loglistentry.highlighted ? Theme.highlightColor : Theme.primaryColor
                        text: name
                    }

                    Label {
                        width: parent.width / 3
                        color: loglistentry.highlighted ? Theme.highlightColor : Theme.primaryColor
                        text: type
                    }
                }

                onClicked: {
                    pageStack.push(Qt.resolvedUrl("LogBookEntryDetails.qml"),{ logentry: app.logbook.logentries.get(index) });
                }
            }
        }
    }
}
