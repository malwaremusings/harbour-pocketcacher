import QtQuick 2.2

Item {
    property alias caches: lstCaches
    property alias cachesFound: lstCachesFound

    ListModel {
        id: lstCaches
    }

    ListModel {
        id: lstCachesFound
    }
}
