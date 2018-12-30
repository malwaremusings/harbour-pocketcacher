#ifndef GEOCACHEDATASOURCE_H
#define GEOCACHEDATASOURCE_H

#include <QObject>
#include <QUrl>
#include "cache.h"
#include "cachelistmodel.h"

class GeocacheDataSource : public QObject
{
    Q_OBJECT
    Q_PROPERTY(CacheListModel * model READ model WRITE setModel NOTIFY modelChanged)
    Q_PROPERTY(QUrl source READ source WRITE setSource NOTIFY sourceChanged)
    Q_PROPERTY(qint8 status READ status NOTIFY statusChanged)
        /* 1: Ready (XmlListModel.Ready)
         * 2: Loading (XmlListModel.Loading)
         */

public:
    explicit GeocacheDataSource(QObject *parent = nullptr);
    // GeocacheDataSource(CacheListModel m, QUrl source);

    CacheListModel *model() { return this -> m_model; }
    void setModel(CacheListModel *model) {
        qDebug() << "GeocacheDataSource::setModel(" << model << ")";
        this -> m_model = model;
        emit modelChanged();
    }

    QUrl source() { return this -> m_source; }
    void setSource(QUrl source) {
        if (m_source != source) {
            qDebug() << "GeocacheDataSource::setSource(" << source << ")";
            this -> m_source = source;
            emit sourceChanged();
        }
    }

    qint8 status();
    void setStatus(qint8 status);

    /*
     * load the caches in to the 'caches' QVector
     */
    virtual bool loadCaches() = 0;

    /*
     * read and remove a cache from the 'caches' QVector
     */
    // Cache *getLastCache();

private:
    CacheListModel *m_model;
    QUrl m_source;
    qint8 m_status;

protected:
    void addCache(Cache *cache) {
        qDebug() << "GeocacheDataSource::addCache(\"" << cache -> name() << "\"";
        m_model -> addCache(cache);
        // emit cacheAdded(cache);
    }

signals:
    void sourceChanged();
    void modelChanged();
    void statusChanged();
    // void cacheAdded(Cache *cache);

public slots:
};

#endif // GEOCACHEDATASOURCE_H