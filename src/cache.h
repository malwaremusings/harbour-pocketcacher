#ifndef CACHE_H
#define CACHE_H

#include <QObject>
#include <QGeoCoordinate>
#include <QDebug>

class Cache : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString name READ name CONSTANT)
    Q_PROPERTY(QString gsname READ gsname CONSTANT)
    Q_PROPERTY(qreal lat READ lat CONSTANT)
    Q_PROPERTY(qreal lon READ lon CONSTANT)
    Q_PROPERTY(QString time READ time CONSTANT)
    Q_PROPERTY(QString type READ type CONSTANT)
    Q_PROPERTY(qreal difficulty READ difficulty CONSTANT)
    Q_PROPERTY(qreal terrain READ terrain CONSTANT)
    Q_PROPERTY(QString container READ container CONSTANT)
    Q_PROPERTY(QString owner READ owner CONSTANT)
    Q_PROPERTY(QString short_description READ short_description CONSTANT)
    Q_PROPERTY(QString long_description READ long_description CONSTANT)
    Q_PROPERTY(QString encoded_hints READ encoded_hints CONSTANT)
    Q_PROPERTY(QString lastFound READ lastFound CONSTANT)
    // Q_PROPERTY(qreal distance READ distance WRITE setDistance NOTIFY distanceChanged)
    // Q_PROPERTY(qreal bearing READ bearing WRITE setBearing NOTIFY bearingChanged)
    Q_PROPERTY(int navigateStart READ navigateStart WRITE setNavigateStart NOTIFY navigateStartChanged)
    Q_PROPERTY(int navigateEnd READ navigateEnd WRITE setNavigateEnd NOTIFY navigateEndChanged)
    Q_PROPERTY(int searchStart READ searchStart WRITE setSearchStart NOTIFY searchStartChanged)
    Q_PROPERTY(int searchEnd READ searchEnd WRITE setSearchEnd NOTIFY searchEndChanged)

public:
    explicit Cache(QObject *parent = nullptr);
    ~Cache();
    // explicit Cache(QObject *parent = nullptr, Cache *cache = nullptr);

    QString name() const;
    QString gsname() const;
    qreal   lat() const;
    qreal   lon() const;
    QString time() const;
    QString type() const;
    qreal   difficulty() const;
    qreal   terrain() const;
    QString container() const;
    QString owner() const;
    QString short_description() const;
    QString long_description() const;
    QString encoded_hints() const;
    QString lastFound() const;
    // qreal   distance() const;
    // qreal   bearing() const;
    int     navigateStart() const;
    int     navigateEnd() const;
    int     searchStart() const;
    int     searchEnd() const;

    void setName(QString name);
    void setGsname(QString gsname);
    void setLat(qreal lat);
    void setLon(qreal lon);
    void setTime(QString time);
    void setType(QString type);
    void setDifficulty(qreal difficulty);
    void setTerrain(qreal terrain);
    void setContainer(QString container);
    void setOwner(QString owner);
    void setShort_description(QString short_description);
    void setLong_description(QString long_description);
    void setEncoded_hints(QString encoded_hints);
    void setLastFound(QString lastFound);
    // void setDistance(qreal distance);
    // void setBearing(qreal bearing);
    void setNavigateStart(int navigateStart);
    void setNavigateEnd(int navigateEnd);
    void setSearchStart(int searchStart);
    void setSearchEnd(int searchEnd);

signals:
    // void nameChanged(QString name);
    // void gsnameChanged(QString gsname);
    // void latChanged(qreal lat);
    // void lonChanged(qreal lon);
    // void timeChanged(QString time);
    // void typeChanged(QString type);
    // void difficultyChanged(qreal difficulty);
    // void terrainChanged(qreal terrain);
    // void containerChanged(QString container);
    // void ownerChanged(QString owner);
    // void short_descriptionChanged(QString short_description);
    // void long_descriptionChanged(QString long_description);
    // void encoded_hintsChanged(QString encoded_hints);
    // void lastFoundChanged(QString lastFound);
    // void distanceChanged();
    // void bearingChanged();
    void navigateStartChanged();
    void navigateEndChanged();
    void searchStartChanged();
    void searchEndChanged();

private:
    QString m_name;
    QString m_gsname;
    qreal   m_lat;
    qreal   m_lon;
    QString m_time;
    QString m_type;
    qreal   m_difficulty;
    qreal   m_terrain;
    QString m_container;
    QString m_owner;
    QString m_short_description;
    QString m_long_description;
    QString m_encoded_hints;
    QString m_lastFound;
    // qreal   m_distance = -1;
    // qreal   m_bearing = -1;
    int     m_navigateStart = 0;
    int     m_navigateEnd = 0;
    int     m_searchStart = 0;
    int     m_searchEnd = 0;

public slots:
};
#endif // CACHE_H
