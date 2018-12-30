#ifndef CACHELISTMODEL_H
#define CACHELISTMODEL_H

#include <QObject>
#include <QAbstractListModel>
// #include <QQmlListProperty>
#include <QGeoPositionInfo>
#include <QDebug>
#include "cache.h"

class CacheListModel : public QAbstractListModel
{
    Q_OBJECT

public:
    explicit CacheListModel(QObject *parent = nullptr);

    enum CacheRoles {
        GsNameRole = Qt::UserRole + 1,
        TypeRole,
        NameRole,
        DifficultyRole,
        TerrainRole,
        DistanceRole,
        BearingRole
    };

    /*** Model/View Programming: Model Subclassing Reference ***
     *   http://doc.qt.io/qt-5/model-view-programming.html#model-subclassing-reference
     ***/
    // Qt::ItemFlags flags(const QModelIndex &index) const;
    QVariant data(const QModelIndex &index, int role) const;
    // QVariant headerData(int section, Qt::Orientation orientation, int role) const;
    int rowCount(const QModelIndex &parent = QModelIndex()) const;

    /* for read/write models */
    // bool setData(const QModelIndex &index, const QVariant &value, int role);
    // bool setHeaderData(int section, Qt::Orientation orientation, const QVariant &value, int role);

    /***/

    // QHash<int,QByteArray> roleNames() const;

    Q_INVOKABLE void addCache(Cache *cache);
    Q_INVOKABLE Cache *getCache(int index);

protected:
    QHash<int,QByteArray> roleNames() const;

private:
    QVector<Cache *> m_caches;
    // QVector<> m_caches;
    // QGeoPositionInfo m_position;
    QGeoCoordinate m_position;

signals:

public slots:
    /* Ideally this should be a separate object and anything that needs to know
     * our position queries it, when it needs to know, rather than the position
     * object pushing the update info to any other module that needs to know!
     */
    void positionUpdated(const QGeoCoordinate &info);
};

#endif // CACHELISTMODEL_H
