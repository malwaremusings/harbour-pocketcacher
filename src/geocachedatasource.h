#ifndef GEOCACHEDATASOURCE_H
#define GEOCACHEDATASOURCE_H

#include <QObject>
#include <QUrl>
#include "cache.h"
#include "cachesortfiltermodel.h"

class GeocacheDataSource : public QObject
{
    Q_OBJECT

    Q_PROPERTY(CacheSortFilterModel * model READ model WRITE setModel NOTIFY modelChanged)
    Q_PROPERTY(QUrl source READ source WRITE setSource NOTIFY sourceChanged)
    Q_PROPERTY(Status status READ status NOTIFY statusChanged)

public:
    enum Status {
        Null = 0,   /* no data loaded       */
        Ready,      /* data loaded          */
        Loading,    /* data loading         */
        Error       /* error loading data   */
    };
    Q_ENUM(Status)

    explicit GeocacheDataSource(QObject *parent = nullptr);
    // GeocacheDataSource(CacheListModel m, QUrl source);

    CacheSortFilterModel *model() { return this -> m_model; }
    void setModel(CacheSortFilterModel *model) {
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

    Status status();
    void setStatus(Status status);

    /*
     * load the caches in to the 'caches' QVector
     */
    virtual bool loadCaches() = 0;

    /*
     * read and remove a cache from the 'caches' QVector
     */
    // Cache *getLastCache();

private:
    CacheSortFilterModel *m_model;
    Status m_status = Null;
    QUrl m_source;

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
