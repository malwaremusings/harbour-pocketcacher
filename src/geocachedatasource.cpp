#include "geocachedatasource.h"

GeocacheDataSource::GeocacheDataSource(QObject *parent) : QObject(parent)
{

}

qint8 GeocacheDataSource::status()
{
    return m_status;
}

void GeocacheDataSource::setStatus(qint8 status)
{
    if (m_status != status) {
        m_status = status;
        emit statusChanged();
    }
}

#if 0
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
#endif
