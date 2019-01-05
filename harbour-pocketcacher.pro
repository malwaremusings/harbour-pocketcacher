# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = harbour-pocketcacher

CONFIG += sailfishapp

QT += location multimedia

SOURCES += src/harbour-pocketcacher.cpp \
    src/Beeper.cpp \
    src/cachelistmodel.cpp \
    src/cache.cpp \
    src/geocachedatasource.cpp \
    src/pocketquerydatasource.cpp \
    src/cachesortfiltermodel.cpp

DISTFILES += qml/harbour-pocketcacher.qml \
    qml/cover/CoverPage.qml \
    qml/pages/FirstPage.qml \
    rpm/harbour-pocketcacher.changes.in \
    rpm/harbour-pocketcacher.changes.run.in \
    rpm/harbour-pocketcacher.spec \
    rpm/harbour-pocketcacher.yaml \
    translations/*.ts \
    harbour-pocketcacher.desktop \
    qml/pages/CacheList.qml \
    qml/pages/PocketQueries.qml \
    qml/PocketQueryJavascript.js \
    qml/pages/CacheDetails.qml \
    qml/pages/CacheMap.qml \
    qml/pages/CacheNavigate.qml \
    qml/pages/CacheLogger.qml \
    qml/pages/LogBookEntryDetails.qml \
    qml/pages/SaveFileDialog.qml \
    qml/harbour-pocketcacher.js \
    qml/Database.qml \
    qml/PocketQuery.qml.dontuse \
    qml/pages/CacheListOptionsDialog.qml

SAILFISHAPP_ICONS = 86x86 108x108 128x128

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n

# German translation is enabled as an example. If you aren't
# planning to localize your app, remember to comment out the
# following TRANSLATIONS line. And also do not forget to
# modify the localized app name in the the .desktop file.
TRANSLATIONS += translations/harbour-pocketcacher-de.ts

HEADERS += \
    src/Beeper.h \
    src/cachelistmodel.h \
    src/cache.h \
    src/geocachedatasource.h \
    src/pocketquerydatasource.h \
    src/cachesortfiltermodel.h
