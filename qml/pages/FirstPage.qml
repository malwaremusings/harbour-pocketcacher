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
import Sailfish.Silica 1.0


Page {
    id: page

    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.All

    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaFlickable {
        anchors.fill: parent

        // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
        PullDownMenu {
            /*
             * future feature to allow management of loaded pocket queries
             */
            //MenuItem {
            //    text: qsTr("PocketQueries")
            //    onClicked: pageStack.push(Qt.resolvedUrl("PocketQueries.qml"))
            //}

            MenuItem {
                text: qsTr("Log Book")
                onClicked: pageStack.push(Qt.resolvedUrl("LogBook.qml"))
            }

            MenuItem {
                text: qsTr("Geocaches")
                onClicked: pageStack.push(Qt.resolvedUrl("CacheList.qml"))
            }
        }

        // Tell SilicaFlickable the height of its content.
        contentHeight: column.height

        // Place our content in a Column.  The PageHeader is always placed at the top
        // of the page, followed by our content.
        Column {
            id: column

            width: page.width
            spacing: Theme.paddingLarge
            PageHeader {
                title: qsTr("Pocket Cacher")
            }
            Label {
                x: Theme.horizontalPageMargin
                text: qsTr("<b>Hello Cachers</b>")
                color: Theme.secondaryHighlightColor
                font.pixelSize: Theme.fontSizeExtraLarge
            }

            SectionHeader {
                text: qsTr("Information")
            }

            DetailItem {
                x: Theme.horizontalPageMargin
                label: qsTr("Loaded caches")
                value: app.caches.count
            }

            DetailItem {
                x: Theme.horizontalPageMargin
                label: qsTr("Logbook entries")
                value: app.logbook.logentries.count
            }

            SectionHeader {
                text: qsTr("My Position")
                visible: app.myPosition.coordinate.isValid
            }

            DetailItem {
                x: Theme.horizontalPageMargin
                label: qsTr("Latitude")
                value: app.myPosition.coordinate.latitude
                visible: app.myPosition.coordinate.isValid
            }

            DetailItem {
                x: Theme.horizontalPageMargin
                label: qsTr("Longitude")
                value: app.myPosition.coordinate.longitude
                visible: app.myPosition.coordinate.isValid
            }

            DetailItem {
                x: Theme.horizontalPageMargin
                label: qsTr("Altitude")
                value: qsTr(app.myPosition.coordinate.altitude + " m")
                visible: app.myPosition.coordinate.isValid
            }

            DetailItem {
                x: Theme.horizontalPageMargin
                label: qsTr("Accuracy")
                value: qsTr(app.myPosition.horizontalAccuracy + " m")
                visible: app.myPosition.horizontalAccuracyValid
            }

            DetailItem {
                x: Theme.horizontalPageMargin
                label: qsTr("Timestamp")
                value: app.myPosition.timestamp
                visible: app.myPosition.coordinate.isValid
            }
        }
    }
}
