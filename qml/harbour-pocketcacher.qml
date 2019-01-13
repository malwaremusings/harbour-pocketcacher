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
import QtPositioning 5.3
import QtSensors 5.0
// import Nemo.Notifications 1.0    /* for placing messages on status/notifications page                      */
                                    /* see https://sailfishos.org/develop/docs/nemo-qml-plugin-notifications/ */
import com.malwaremusings 0.2
import "pages"


ApplicationWindow
{
    id: app
    property alias caches: caches
    property alias myPosition: posSource.position
    property real myDirection: (compass.direction != -999) ? compass.direction : posSource.direction
    property alias logbook: logbook
    //property alias cachemodel: caches
    //property alias allcaches: cache
    property alias pqds: pqds
    property alias satinfo: satinfo
    property alias beeper: beeper

    CacheSortFilterModel {
        id: caches
        property bool sortEnabled
        property int  sortOrder

        property bool filterEnabled

        /* I suspect case sensitive sorting would confuse most people! */
        sortCaseSensitivity: Qt.CaseInsensitive

        onSortEnabledChanged: {
            console.debug("CacheSortFilterModelQML onSortEnabledChanged(): " + sortEnabled);
            startSort(sortEnabled ? 0 : -1,sortOrder);
        }

        onFilterEnabledChanged: {
            console.debug("CacheSortFilterModelQML onFilterEnabledChanged(): " + filterEnabled);

            /*
             * do we need to disable filtering?
             * note that it is enabled by setting the filterRegExp string when the dialog box is accepted
             */
            if (!filterEnabled) filterRegExp = new RegExp("(?:)");  /* this is the regexp that filterRegExp is initialised with */
        }
    }

    PocketQueryDataSource {
        id: pqds
        model: caches

        onSourceChanged: {
            loadCaches();
        }
    }

    LogBookModel {
        id: logbook

        property alias db: dbLogBookModel

        Database {
            id: dbLogBookModel
        }
    }

    CacherSatelliteInfoSource {
        id: satinfo

        updateInterval: 0
        active: true
    }

    PositionSource {
        id: posSource
        updateInterval: 0   /* changing this doesn't seem to do anything! */
        active: true

        property double previouslat: -999
        property double previouslon: -999
        property real direction
        property int num: 0

        onPositionChanged: {
            // console.debug("Position changed: " + position.coordinate.latitude + "," + position.coordinate.longitude + "," + position.coordinate.altitude);

            /* calculate direction if compass sensor is unavailable */
            if (position.directionValid) {
                direction = position.direction;
                console.debug("position direction: " + direction);
            } else {
                if (previouslat != -999) {
                    var previouscoords = QtPositioning.coordinate(previouslat,previouslon);
                    direction = previouscoords.azimuthTo(position.coordinate);
                } else {
                    direction = -999;
                }
            }

            // console.debug("    dir: " + direction);
            // console.debug("    speed (" + position.speedValid + "): " + position.speed);

            previouslat = position.coordinate.latitude;
            previouslon = position.coordinate.longitude;

            caches.positionUpdated(position.coordinate);
        }
    }

    Compass {
        id: compass

        property real direction: -999

        Component.onCompleted: {
            if (connectedToBackend) {
                console.debug("Compass is connected");
                start();
                compassTimer.start();
            } else {
                console.debug("Compass is unavailable");
            }
        }
    }

    /*
     * Use a timer as the Compass sensor produces a large
     * number of unecessary readings
     */
    Timer {
        id: compassTimer

        interval: 1000
        running: false
        triggeredOnStart: true
        repeat: true
        onTriggered: {
            compass.direction = compass.reading.azimuth;
        }
    }

    Beeper {
        id: beeper

        Component.onCompleted: {
            // beeper.beep(220,1);
            beeper.open();
            beeper.setDuration(0.075);
            beeper.setFrequency(440);
            // beeper.beep(880,1);
        }
    }

    initialPage: Component { FirstPage { } }
    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    allowedOrientations: defaultAllowedOrientations
}
