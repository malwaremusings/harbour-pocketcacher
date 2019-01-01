#ifndef CACHELISTMODEL_H
#define CACHELISTMODEL_H

#include <QObject>
#include <QAbstractListModel>
// #include <QQmlListProperty>
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
        LatRole,
        LonRole
    };
    Q_ENUM(CacheRoles)

    /*** Model/View Programming: Model Subclassing Reference ***
     *   http://doc.qt.io/qt-5/model-view-programming.html#model-subclassing-reference
     ***/
    // Qt::ItemFlags flags(const QModelIndex &index) const;
    QVariant data(const QModelIndex &index, int role) const;
    // QVariant headerData(int section, Qt::Orientation orientation, int role) const;
    int rowCount(const QModelIndex &parent = QModelIndex()) const;

#if 0
    /* for read/write models */
    bool setData(const QModelIndex &index, const QVariant &value, int role);
    bool setHeaderData(int section, Qt::Orientation orientation, const QVariant &value, int role);
#endif

    /***/

    // QHash<int,QByteArray> roleNames() const;

    Q_INVOKABLE void addCache(Cache *cache);
    Q_INVOKABLE Cache *getCache(int index);

protected:
    QHash<int,QByteArray> roleNames() const;

private:
    QVector<Cache *> m_caches;
    // QGeoPositionInfo m_position;
    // QGeoCoordinate m_position;

signals:

public slots:
};

#endif // CACHELISTMODEL_H
