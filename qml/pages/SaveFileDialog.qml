import QtQuick 2.2
import Sailfish.Silica 1.0

/*
 * currently unused until i can get file i/o
 * working, which i suspect will require a c++
 * module
 */

Dialog {
    id: dialogSaveFile
    property alias filename: txtfldFilename.text

    SilicaFlickable {
        anchors.fill: parent

        Column {
            width: parent.width

            DialogHeader {
                title: "Save File"
            }

            TextField {
                id: txtfldFilename

                width: parent.width
                label: "Filename"
                placeholderText: "Enter filename"
                focus: true

                validator: RegExpValidator {
                    regExp: /[A-Za-z0-9 _.-]+/
                }

                Component.onCompleted:
                    txtfldFilename.selectAll();
            }
        }
    }
}
