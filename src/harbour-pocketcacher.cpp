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

// #ifdef QT_QML_DEBUG
#include <QtQuick>
// #endif

#include <sailfishapp.h>
#include "beeper.h"
#include "cachelistmodel.h"
#include "pocketquerydatasource.h"
#include "cachesortfiltermodel.h"
#include "cachersatelliteinfosource.h"
#include "cachernetworkaccessmanager.h"
#include "okapidatasource.h"
#include "cacheroauth.h"

int main(int argc, char *argv[])
{
    // SailfishApp::main() will display "qml/harbour-pocketcacher.qml", if you need more
    // control over initialization, you can use:
    //
    //   - SailfishApp::application(int, char *[]) to get the QGuiApplication *
    //   - SailfishApp::createView() to get a new QQuickView * instance
    //   - SailfishApp::pathTo(QString) to get a QUrl to a resource file
    //   - SailfishApp::pathToMainQml() to get a QUrl to the main QML file
    //
    // To display the view, call "show()" (will show fullscreen on device).

    // See https://sailfishos.org/wiki/Tutorial_-_Combining_C%2B%2B_with_QML
    QScopedPointer<QGuiApplication> app(SailfishApp::application(argc,argv));
    QScopedPointer<QQuickView> view(SailfishApp::createView());
    view -> rootContext() -> setContextProperty("Build",QString(__DATE__ "T" __TIME__));

    /* The APP_VERSION and APP_BUILDNUM constants are defined in the .pro file using 'DEFINES' */
    /* See https://github.com/amarchen/helloworld-pro-sailfish/commit/a9ae28197267fb6f94484e9e27a4bbcf7abaaf16#diff-b820e0828543b1da522ff0ab3dac6c75 */
    // view -> rootContext() -> setContextProperty("appVersion",APP_VERSION);
    // view -> rootContext() -> setContextProperty("appBuildNum",APP_BUILDNUM);

    qmlRegisterType<Beeper>("com.malwaremusings",0,2,"Beeper");
    qmlRegisterType<Cache>("com.malwaremusings",0,2,"Cache");
    qmlRegisterType<CacheListModel>("com.malwaremusings",0,2,"CacheListModel");
    qmlRegisterType<PocketQueryDataSource>("com.malwaremusings",0,2,"PocketQueryDataSource");
    qmlRegisterType<CacheSortFilterModel>("com.malwaremusings",0,2,"CacheSortFilterModel");
    qmlRegisterType<CacherSatelliteInfoSource>("com.malwaremusings",0,2,"CacherSatelliteInfoSource");
    qmlRegisterType<OKAPIDataSource>("com.malwaremusings",0,2,"OKAPIDataSource");
    qmlRegisterType<CacherNetworkAccessManager>("com.malwaremusings",0,2,"CacherNetworkAccessManager");
    qmlRegisterType<CacherOAuth>("com.malwaremusings",0,2,"CacherOAuth");

    view -> setSource(SailfishApp::pathTo("qml/harbour-pocketcacher.qml"));
    view -> show();

    return app -> exec();
    // return SailfishApp::main(argc, argv);
}
