#include "cachelistmodel.h"

// CacheListModel::CacheListModel(QObject *parent) : QObject(parent)
CacheListModel::CacheListModel(QObject *parent) : QAbstractListModel(parent)
{
    qDebug() << "> CacheListModel(" << parent << ")";
    qDebug() << "    GsNameRole: " << GsNameRole;
    qDebug() << "< CacheListModel(" << parent << ")";
}

#if 0
Qt::ItemFlags CacheListModel::flags(const QModelIndex &index) const
{
    /* OR Qt::ItemIsEditable if we want read/write model */
    return QAbstractListModel::flags(index);
}
#endif

/* necessary to compile */
QVariant CacheListModel::data(const QModelIndex &index, int role) const
{
    QVariant ret = QVariant();
    const Cache    *item;

    qDebug() << "CacheListModel::data(" << index << "," << role << ")";
    item = m_caches.at(index.row());
    if (item) {
        switch (role) {
        case GsNameRole:
            ret = item -> gsname();
            break;
        case TypeRole:
            ret = item -> type();
            break;
        case NameRole:
            ret = item -> name();
            break;
        case DifficultyRole:
            ret = item -> difficulty();
            break;
        case TerrainRole:
            ret = item -> terrain();
            break;
        case LatRole:
#if 0
            /* calculate distance from our current location */
            /* return -1 if we can't get a valid distance   */
            if (m_position.isValid()) {
                ret = m_position.distanceTo(QGeoCoordinate(item -> lat(),item -> lon()));
            } else {
                ret = -1;
            }
#endif
            ret = item -> lat();
            break;
        case LonRole:
            ret = item -> lon();
            break;
        }
    }

    return ret;
}

#if 0
QVariant CacheListModel::headerData(int section, Qt::Orientation orientation, int role) const
{

}
#endif

/* necessary to compile */
int CacheListModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);

    return m_caches.count();
}

#if 0
/* for read/write models */
bool CacheListModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    /* must emit dataChanged() signal after changing data */
}

bool CacheListModel::setHeaderData(int section, Qt::Orientation orientation, const QVariant &value, int role)
{

}
#endif
/***/

QHash<int, QByteArray>CacheListModel::roleNames() const {
    static QHash<int,QByteArray> roles;

    roles[GsNameRole] = "gsname";
    roles[TypeRole] = "type";
    roles[NameRole] = "name";
    roles[DifficultyRole] = "difficulty";
    roles[TerrainRole] = "terrain";
    roles[LatRole] = "lat";
    roles[LonRole] = "lon";

    return roles;
}

/* custom methods */
void CacheListModel::addCache(Cache *cache)
{
    qDebug() << "> CacheListModel::addCache()";
    qDebug() << "    " << cache -> name();
    beginInsertRows(QModelIndex(), rowCount(), rowCount());
    m_caches << cache;
    endInsertRows();
    qDebug() << "< CacheListModel::addCache()";
}

Cache *CacheListModel::getCache(int index)
{
    return m_caches[index];
}
