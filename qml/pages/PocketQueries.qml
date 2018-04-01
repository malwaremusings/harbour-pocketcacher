import QtQuick 2.0
import Sailfish.Silica 1.0
import ".."
// import "../PocketQueryJavascript.js" as PocketQueryJavascript

Page {
    id: pagePocketQueryList
    property alias listPocketQueries: listPocketQueries
    property alias text: delegateText

    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.All

    SilicaFlickable {
        anchors.fill: parent

        PullDownMenu {
            MenuItem {
                text: qsTr("Add PocketQuery")
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("PocketQueryAdd.qml"));
                }
            }
        }

        ListModel {
            id: listPocketQueries
        }

        SilicaListView {
            id: listViewPocketQueries
            anchors.fill: parent

            model: listPocketQueries

            Item {
                id: delegateItem

                Text {
                    id: delegateText

                    text: ""
                }
            }
        }
    }

    Loader {
        id: ldrPocketQuery

        onLoaded: {
            binder.target = ldrPocketQuery.item
        }
    }

    Binding {
        id: binder

        property: "filename"
        value: delegateText.text
    }

    //function pocketQueryCreated(pq) {
    //    listPocketQueries.append({"obj": pq});
    //}

    //function pocketQueryLoad(strFilename) {
    //    console.debug("> PocketQueries.qml::pocketQueryLoad(" + strFilename + ")");
    //    PocketQueryJavascript.createPocketQuery(strFilename,pocketQueryCreated);
    //}

    function pocketQueryLoad(strFilename) {
        ldrPocketQuery.source = "../PocketQuery.qml"
    }
}
