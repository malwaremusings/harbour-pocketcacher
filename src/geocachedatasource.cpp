#include "geocachedatasource.h"

GeocacheDataSource::GeocacheDataSource(QObject *parent) : QObject(parent)
{

}

Cache *GeocacheDataSource::getLastCache() {
    Cache *c = nullptr;

    qDebug() << "GeocacheDataSource::getLastCache()";

    if (!caches.isEmpty()) {
        // c = caches.takeFirst();
        c = caches.last();
    }

    qDebug() << "    returning \"" << c -> getName() << "\"";
    return c;
}
