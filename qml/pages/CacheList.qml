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

import QtQuick 2.2
// import QtQuick.Layouts 1.1
import QtPositioning 5.3
import Sailfish.Silica 1.0
import Sailfish.Pickers 1.0
// import com.malwaremusings 0.1    /* for PocketQueryDataSource enum Status */
import ".."

Page {
    id: pageCacheList

    // property alias filename: pocketquery.filename

    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.All

    // PocketQuery {
    //     id: pocketquery
    //     filename: ""
    // }

    SilicaFlickable {
        anchors.fill: parent

        SilicaListView {
            id: listView

            anchors.fill: parent

            model: app.caches

            header: PageHeader {
                title: qsTr("Geocaches")
            }
            spacing: 2

            PullDownMenu {
                MenuItem {
                    text: qsTr("Sort")
                    onClicked: {
                        var sortDialog = pageStack.push(Qt.resolvedUrl("CacheSortDialog.qml"),{ role: app.caches.sortRole });
                        sortDialog.accepted.connect(function() {
                            app.caches.sortRole = sortDialog.role;
                            app.caches.startSort(0,sortDialog.order);
                        });
                    }
                }

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

            VerticalScrollDecorator {}

            ViewPlaceholder {
                id: placeholder

                enabled: (listView.count === 0)
                text: qsTr("No geocaches loaded")
                hintText: qsTr("Load a pocket query")

                // state: (app.pqds.status === PocketQueryDataSource.Loading) ? qsTr("Loading") : ""
                // states: [
                //     State {
                //         name: ""
                //         PropertyChanges { target: placeholder; text: "No geocaches loaded"; hintText: "Load a pocket query" }
                //         },

                //     State {
                //         name: "Loading"
                //         PropertyChanges { target: placeholder; text: "Loading geocaches"; hintText: "" }
                //     }
                // ]
            }

            delegate: BackgroundItem {
                id: delegate

                /*
                 * Calculating these here rather than in the 'Label' object stops the ListView from
                 * needlessly fetching the cache's lon and lat for every position update
                 */
                property var cachecoords: QtPositioning.coordinate(lat,lon)
                property var hereiam: app.myPosition.coordinate
                property real distance: hereiam.distanceTo(cachecoords)
                property real bearing: hereiam.azimuthTo(cachecoords)

                // visible: app.pqds.status !== PocketQueryDataSource.Loading

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
                            /*
                             * Wrapping the text causes the cache name to be
                             * placed on top of the gsname in the next cell
                             * down
                             */
                            // wrapMode: Text.Wrap
                        }

                        Label {
                            width: parent.width / parent.columns
                            text: qsTr(type)
                            color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
                            horizontalAlignment: Text.AlignRight
                            truncationMode: TruncationMode.Fade
                            // wrapMode: Text.Wrap
                        }

                        Label {
                            width: parent.width / parent.columns
                            text: qsTr(name)
                            color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
                            horizontalAlignment: Text.AlignLeft
                            truncationMode: TruncationMode.Fade
                            // wrapMode: Text.Wrap
                        }

                        Row {
                            width: parent.width / parent.columns

                            Label {
                                width: parent.width / 2
                                text: difficulty + "/" + terrain
                                color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
                                horizontalAlignment: Text.AlignRight
                            }

                            Label {
                                width: parent.width / 2
                                text: Math.round(distance) + " m"
                                color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
                                horizontalAlignment: Text.AlignRight
                                visible: distance != -1
                            }
                        }
                    }
                }

                onClicked: {
                    console.debug("Clicked " + qsTr(name));
                    console.debug("    " + index);

                    pageStack.push(Qt.resolvedUrl("CacheDetails.qml"),{ cache: listView.model.getCache(index) });
                }
            }
            VerticalScrollDecorator {}

            // BusyIndicator {
            //     anchors.verticalCenter: parent.verticalCenter
            //     anchors.horizontalCenter: parent.horizontalCenter

            //     size: BusyIndicatorSize.Large
            //     running: app.pqds.status === PocketQueryDataSource.Loading
            // }
        }
    }

    /* https://sailfishos.org/develop/docs/sailfish-components-pickers/qml-sailfish-pickers-filepickerpage.html/ */
    Component {
        id: filePickerPage

        FilePickerPage {
            anchors.leftMargin: Theme.horizontalPageMargin
            anchors.rightMargin: Theme.horizontalPageMargin

            title: "Select Pocket Query File"
            nameFilters: [ '*.gpx' ]
            onSelectedContentPropertiesChanged: {
                // pocketquery.filename = selectedContentProperties.filePath;
                app.pqds.source = Qt.resolvedUrl(selectedContentProperties.filePath);
                // app.pqds.loadCaches();
            }
        }
    }
}
