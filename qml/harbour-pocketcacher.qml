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
import QtQuick.LocalStorage 2.0
import "pages"


ApplicationWindow
{
    id: app
    property alias caches: caches.caches
    property alias myPosition: posSource.position
    property alias myDirection: posSource.direction
    property alias logbook: logbook
    property var   db
    // property alias cachemodel: cacheModelJS.cacheModel
    // property alias cachemodel: caches.cacheModelJS
    property alias cachemodel: caches
    property alias allcaches: caches.allcaches


    CacheModel {
        id: caches
    }

    LogBookModel {
        id: logbook
    }

    PositionSource {
        id: posSource
        updateInterval: 1000
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

            caches.refresh_distances();
        }
    }

    initialPage: Component { FirstPage { } }
    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    allowedOrientations: defaultAllowedOrientations
}
