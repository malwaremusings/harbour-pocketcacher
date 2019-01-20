import QtQuick 2.2
import Sailfish.Silica 1.0
import Sailfish.Pickers 1.0

/*
 * currently unused until i can get file i/o
 * working, which i suspect will require a c++
 * module
 */

Dialog {
    id: dialogCacheFetch

    SilicaFlickable {
        anchors.fill: parent

        Column {
            width: parent.width

            DialogHeader {
                title: "Load Caches"
            }

            ComboBox {
                id: comboCacheDataSource

                label: "Source"
                width: parent.width

                menu: ContextMenu {
                    MenuItem { text: "Pocket Query" }
                    MenuItem { text: "OpenCaching" }
                }
            }

            TextField {
                id: textFilename

                label: qsTr("Filename")
                placeholderText: qsTr("Filename")
                width: parent.width
                visible: comboCacheDataSource.currentIndex === 0

                onClicked: {
                    pageStack.push(filePickerPage);
                }
            }

            ComboBox {
                id: comboSite

                label: qsTr("Site")
                width: parent.width
                visible: comboCacheDataSource.currentIndex === 1

                menu: ContextMenu {
                    MenuItem {
                        property string hostname: "opencache.uk"
                        text: qsTr("United Kingdom")
                    }

                    MenuItem {
                        property string hostname: "opencaching.de"
                        text: qsTr("Germany")
                    }
                }
            }
        }
    }

    /* https://sailfishos.org/develop/docs/sailfish-components-pickers/qml-sailfish-pickers-filepickerpage.html/ */
    Component {
        id: filePickerPage

        FilePickerPage {
            // anchors.leftMargin: Theme.horizontalPageMargin
            // anchors.rightMargin: Theme.horizontalPageMargin

            title: "Select Pocket Query File"
            nameFilters: [ '*.gpx' ]
            onSelectedContentPropertiesChanged: {
                textFilename.text = selectedContentProperties.filePath;
            }
        }
    }

    onDone: {
        console.debug("CacheFetch::onDone()");
        if (result === DialogResult.Accepted) {
            console.debug("    DialogResult.Accepted");
            switch (comboCacheDataSource.currentIndex) {
            case 0:
                /* PocketQuery */
                console.debug("        Setting pqds source: " + textFilename.text);
                app.pqds.source = Qt.resolvedUrl(textFilename.text);
                break;

            case 1:
                /* OpenCaching */
                console.debug("    OpenCaching: " + comboSite.currentItem.hostname);
                app.okapids.host = comboSite.currentItem.hostname;
                break;
            }
        }
    }
}
