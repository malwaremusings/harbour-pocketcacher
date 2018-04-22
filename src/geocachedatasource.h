#ifndef GEOCACHEDATASOURCE_H
#define GEOCACHEDATASOURCE_H

#include <QObject>
#include <QUrl>
#include "cache.h"

class GeocacheDataSource : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QUrl source READ getSource WRITE setSource)

public:
    explicit GeocacheDataSource(QObject *parent = nullptr);
    GeocacheDataSource(QUrl source);

private:
    QVector<Cache *> caches;

protected:
    QUrl source;

    void addCache(Cache *cache) {
        qDebug() << "GeocacheDataSource::addCache(\"" << cache->getName() << "\"";
        caches.append(cache);
        emit cacheAdded(cache);
    }

signals:
    void sourceChanged(QUrl source);
    void cacheAdded(Cache *cache);

public slots:
    QUrl getSource() { return this -> source; }
    void setSource(QUrl source) { this -> source = source; emit sourceChanged(source); }

    /*
     * load the caches in to the 'caches' QVector
     */
    virtual bool loadCaches() = 0;

    /*
     * read and remove a cache from the 'caches' QVector
     */
    Cache *getLastCache();
};

#endif // GEOCACHEDATASOURCE_H
