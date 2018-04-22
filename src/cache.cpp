#include "cache.h"

Cache::Cache(QObject *parent) : QObject(parent)
{
    qDebug() << "new Cache(" << parent << "): " << this;
}

Cache::~Cache()
{
    qDebug() << "[D] Cache destructor called for " << this;
}

//Cache::Cache(QObject *parent, Cache *cache) : QObject(parent) {
//    qDebug() << "new Cache(" << cache << ")";
//
//    if (cache) *this = *cache;
//}
