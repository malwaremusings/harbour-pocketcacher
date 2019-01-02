#ifndef CACHESORTFILTERMODEL_H
#define CACHESORTFILTERMODEL_H

#include <QObject>
#include <QSortFilterProxyModel>
#include "cachelistmodel.h"

class CacheSortFilterModel : public QSortFilterProxyModel
{
    Q_OBJECT

public:
    explicit CacheSortFilterModel(QObject *parent = nullptr);
    Q_PROPERTY(int loadedCount READ loadedCount NOTIFY loadedCountChanged)

    Q_INVOKABLE void addCache(Cache *cache);
    Q_INVOKABLE Cache *getCache(int index);
    Q_INVOKABLE void startSort(int column, Qt::SortOrder order = Qt::AscendingOrder);
    Q_INVOKABLE int getSortColumn();
    Q_INVOKABLE void stopSort();

private:
    CacheListModel *m_model;

signals:
    void loadedCountChanged();

public slots:
    int loadedCount();
};

#endif // CACHESORTFILTERMODEL_H
