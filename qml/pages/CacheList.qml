/*
  Copyright (C) 2013 Jolla Ltd.
  Contact: Thomas Perl <thomas.perl@jollamobile.com>
  All rights reserved.

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Jolla Ltd nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import QtQuick 2.0
import Sailfish.Silica 1.0
import Sailfish.Pickers 1.0
import ".."

Page {
    id: pageCacheList

    property alias filename: pocketquery.filename

    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.All

    PocketQuery {
        id: pocketquery
        filename: ""

        cachelist.onStatusChanged: {
            console.debug("> cachelist.onStatusChanged: " + status);

            if (status === 2) {  /* XmlListModel.Loading */
            }

            if (status === 1) {  /* XmlListModel.Ready */
                for (var i = 0;i < cachelist.count; i++) {
                    var c = cachelist.get(i);

                    app.caches.append(c);
                }
            }

            console.debug("< cachelist.onStatusChanged: " + status);
        }
    }

    SilicaFlickable {
        anchors.fill: parent

        PullDownMenu {
            MenuItem {
                text: qsTr("Show map")
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("CacheMap.qml"));
                }
            }

            MenuItem {
                text: qsTr("Load PocketQuery")
                onClicked: {
                    pageStack.push(filePickerPage);
                }
            }
        }

        SilicaListView {
            id: listView

            model: app.caches
            anchors.fill: parent
            header: PageHeader {
                title: qsTr("Geocaches")
            }
            spacing: 2

            VerticalScrollDecorator {}

            delegate: BackgroundItem {
                id: delegate

                Column {
                    width: parent.width

                    Grid {
                        anchors.fill: parent
                        anchors.leftMargin: Theme.horizontalPageMargin
                        anchors.rightMargin: Theme.horizontalPageMargin
                        columns: 2

                        Label {
                            width: parent.width / parent.columns
                            text: qsTr(gsname)
                            color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
                            horizontalAlignment: Text.AlignLeft
                            truncationMode: TruncationMode.Fade
                            wrapMode: Text.Wrap
                        }

                        Label {
                            width: parent.width / parent.columns
                            text: qsTr(type)
                            color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
                            horizontalAlignment: Text.AlignRight
                            truncationMode: TruncationMode.Fade
                            wrapMode: Text.Wrap
                        }

                        Label {
                            width: parent.width / parent.columns
                            text: qsTr(name)
                            color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
                            horizontalAlignment: Text.AlignLeft
                            truncationMode: TruncationMode.Fade
                            wrapMode: Text.Wrap
                        }

                        Label {
                            width: parent.width / parent.columns
                            text: difficulty + "/" + terrain
                            color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
                            horizontalAlignment: Text.AlignRight
                        }
                    }
                }

                onClicked: {
                    console.log("Clicked " + qsTr(name));

                    pageStack.push(Qt.resolvedUrl("CacheDetails.qml"),{ cache: app.caches.get(index) });
                }
            }
            VerticalScrollDecorator {}
        }
    }

    /* https://sailfishos.org/develop/docs/sailfish-components-pickers/qml-sailfish-pickers-filepickerpage.html/ */
    Component {
        id: filePickerPage

        FilePickerPage {
            title: "Select Pocket Query File"
            nameFilters: [ '*.gpx' ]
            onSelectedContentPropertiesChanged: {
                pocketquery.filename = selectedContentProperties.filePath;
            }
        }
    }

    Component {
        id: progress

        ProgressBar {
            label: "Loading Pocket Query"
            minimumValue: 0.0
            maximumValue: 1.0
            value: pocketquery.progress
            valueText: value + "%"
        }
    }
}
