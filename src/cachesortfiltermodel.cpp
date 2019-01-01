#include "cachesortfiltermodel.h"
#include "cachelistmodel.h"
#include "cachesortfiltermodel.h"

CacheSortFilterModel::CacheSortFilterModel(QObject *parent) : QSortFilterProxyModel(parent)
{
    m_model = new CacheListModel(this);
    setSourceModel(m_model);
    setDynamicSortFilter(true);
}

void CacheSortFilterModel::addCache(Cache *cache)
{
    qDebug() << "> CacheSortFilterModel::addCache(" << cache -> name() << ")";
    m_model -> addCache(cache);
    qDebug() << "< CacheSortFilterModel::addCache(" << cache -> name() << ")";
}

Cache *CacheSortFilterModel::getCache(int idx)
{
    QModelIndex proxyModelIndex = index(idx,0,QModelIndex());
    QModelIndex sourceModelIndex = this -> mapToSource(proxyModelIndex);
    return m_model -> getCache(sourceModelIndex.row());
}

void CacheSortFilterModel::startSort(int column, Qt::SortOrder order)
{
    sort(column, order);
}

int CacheSortFilterModel::getSortColumn()
{
    return sortColumn();
}

void CacheSortFilterModel::stopSort()
{
    sort(-1);
}
