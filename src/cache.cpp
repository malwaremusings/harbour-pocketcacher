#include "cache.h"

Cache::Cache(QObject *parent) : QObject(parent)
{
    qDebug() << "new Cache(): " << this;
}

Cache::~Cache()
{
    qDebug() << "[D] Cache destructor called for " << this;
}

QString Cache::name() const
{
    return m_name;
}

QString Cache::gsname() const
{
    return m_gsname;
}

qreal Cache::lat() const
{
    return m_lat;
}

qreal Cache::lon() const
{
    return m_lon;
}

QString Cache::time() const
{
    return m_time;
}

QString Cache::type() const
{
    return m_type;
}

qreal Cache::difficulty() const
{
    return m_difficulty;
}

qreal Cache::terrain() const
{
    return m_terrain;
}

QString Cache::container() const
{
    return m_container;
}

QString Cache::owner() const
{
    return m_owner;
}

QString Cache::short_description() const
{
    return m_short_description;
}

QString Cache::long_description() const
{
    return m_long_description;
}

QString Cache::encoded_hints() const
{
    return m_encoded_hints;
}

QString Cache::lastFound() const
{
    return m_lastFound;
}

qreal Cache::distance() const
{
    return m_distance;
}

qreal Cache::bearing() const
{
    return m_bearing;
}

int Cache::navigateStart() const
{
    return m_navigateStart;
}

int Cache::navigateEnd() const
{
    return m_navigateEnd;
}

int Cache::searchStart() const
{
    return m_searchStart;
}

int Cache::searchEnd() const
{
    return m_searchEnd;
}

void Cache::setName(QString name)
{
    if (m_name != name) {
        m_name = name;
        qDebug() << "Cache(" << this << ")::setName(" << m_name << ")";
        // emit nameChanged(m_name);
    }
}

void Cache::setGsname(QString gsname)
{
    if (m_gsname != gsname) {
        m_gsname = gsname;
        qDebug() << "Cache(" << this << ")::setGsname(" << m_gsname << ")";
        // emit gsnameChanged(m_gsname);
    }
}

void Cache::setLat(qreal lat)
{
    if (m_lat != lat) {
        m_lat = lat;
        // emit latChanged(m_lat);
    }
}

void Cache::setLon(qreal lon)
{
    if (m_lon != lon) {
        m_lon = lon;
        // emit lonChanged(m_lon);
    }
}

void Cache::setTime(QString time)
{
    if (m_time != time) {
        m_time = time;
        // emit timeChanged(m_time);
    }
}

void Cache::setType(QString type)
{
    if (m_type != type) {
        m_type = type;
        // emit typeChanged(m_type);
    }
}

void Cache::setDifficulty(qreal difficulty)
{
    if (m_difficulty != difficulty) {
        m_difficulty = difficulty;
        // emit difficultyChanged(m_difficulty);
    }
}

void Cache::setTerrain(qreal terrain)
{
    if (m_terrain != terrain) {
        m_terrain = terrain;
        // emit terrainChanged(m_terrain);
    }
}

void Cache::setContainer(QString container)
{
    if (m_container != container) {
        m_container = container;
        // emit containerChanged(m_container);
    }
}

void Cache::setOwner(QString owner)
{
    if (m_owner != owner) {
        m_owner = owner;
        // emit ownerChanged(m_owner);
    }
}

void Cache::setShort_description(QString short_description)
{
    if (m_short_description != short_description) {
        m_short_description = short_description;
        // emit short_descriptionChanged(m_short_description);
    }
}

void Cache::setLong_description(QString long_description)
{
    if (m_long_description != long_description) {
        m_long_description = long_description;
        // emit long_descriptionChanged(m_long_description);
    }
}

void Cache::setEncoded_hints(QString encoded_hints)
{
    if (m_encoded_hints != encoded_hints) {
        m_encoded_hints = encoded_hints;
        // emit encoded_hintsChanged(m_encoded_hints);
    }
}

void Cache::setLastFound(QString lastFound)
{
    if (m_lastFound != lastFound) {
        m_lastFound = lastFound;
        // emit lastFoundChanged(m_lastFound);
    }
}

void Cache::setDistance(qreal distance)
{
    if (m_distance != distance) {
        m_distance = distance;
        emit distanceChanged(m_distance);
    }
}

void Cache::setBearing(qreal bearing)
{
    if (m_bearing != bearing) {
        m_bearing = bearing;
        emit bearingChanged(m_bearing);
    }
}

void Cache::setNavigateStart(int navigateStart)
{
    if (m_navigateStart != navigateStart) {
        m_navigateStart = navigateStart;
        emit navigateStartChanged(m_navigateStart);
    }
}

void Cache::setNavigateEnd(int navigateEnd)
{
    if (m_navigateEnd != navigateEnd) {
        m_navigateEnd = navigateEnd;
        emit navigateEndChanged(m_navigateEnd);
    }
}

void Cache::setSearchStart(int searchStart)
{
    if (m_searchStart != searchStart) {
        m_searchStart = searchStart;
        emit searchStartChanged(m_searchStart);
    }
}

void Cache::setSearchEnd(int searchEnd)
{
    if (m_searchEnd != searchEnd) {
        m_searchEnd = searchEnd;
        emit searchEndChanged(m_searchEnd);
    }
}

//Cache::Cache(QObject *parent, Cache *cache) : QObject(parent) {
//    qDebug() << "new Cache(" << cache << ")";
//
//    if (cache) *this = *cache;
//}

