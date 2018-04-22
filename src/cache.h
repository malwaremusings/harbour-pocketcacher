#ifndef CACHE_H
#define CACHE_H

#include <QObject>
#include <QDebug>

class Cache : public QObject
{
    Q_OBJECT
    Q_PROPERTY(qreal lat READ getLat WRITE setLat NOTIFY latChanged)
    Q_PROPERTY(qreal lon READ getLon WRITE setLon NOTIFY lonChanged)

public:
    explicit Cache(QObject *parent = nullptr);
    ~Cache();
    // explicit Cache(QObject *parent = nullptr, Cache *cache = nullptr);

    Q_PROPERTY(QString name READ getName WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(QString gsname READ getGsname WRITE setGsname NOTIFY gsnameChanged)
    Q_PROPERTY(QString time READ getTime WRITE setTime NOTIFY timeChanged)
    Q_PROPERTY(QString type READ getType WRITE setType NOTIFY typeChanged)
    Q_PROPERTY(qreal difficulty READ getDifficulty WRITE setDifficulty NOTIFY difficultyChanged)
    Q_PROPERTY(qreal terrain READ getTerrain WRITE setTerrain NOTIFY terrainChanged)
    Q_PROPERTY(QString container READ getContainer WRITE setContainer NOTIFY containerChanged)
    Q_PROPERTY(QString owner READ getOwner WRITE setOwner NOTIFY ownerChanged)
    Q_PROPERTY(QString short_description READ getShort_description WRITE setShort_description NOTIFY short_descriptionChanged)
    Q_PROPERTY(QString long_description READ getLong_description WRITE setLong_description NOTIFY long_descriptionChanged)
    Q_PROPERTY(QString encoded_hints READ getEncoded_hints WRITE setEncoded_hints NOTIFY encoded_hintsChanged)
    Q_PROPERTY(QString lastFound READ getLastFound WRITE setLastFound NOTIFY lastFoundChanged)
    Q_PROPERTY(qreal distance READ getDistance WRITE setDistance NOTIFY distanceChanged)
    Q_PROPERTY(qreal bearing READ getBearing WRITE setBearing NOTIFY bearingChanged)
    Q_PROPERTY(int navigateStart READ getNavigateStart WRITE setNavigateStart NOTIFY navigateStartChanged)
    Q_PROPERTY(int navigateEnd READ getNavigateEnd WRITE setNavigateEnd NOTIFY navigateEndChanged)
    Q_PROPERTY(int searchStart READ getSearchStart WRITE setSearchStart NOTIFY searchStartChanged)
    Q_PROPERTY(int searchEnd READ getSearchEnd WRITE setSearchEnd NOTIFY searchEndChanged)

signals:
    void nameChanged(QString name);
    void gsnameChanged(QString gsname);
    void latChanged(qreal lat);
    void lonChanged(qreal lon);
    void timeChanged(QString time);
    void typeChanged(QString type);
    void difficultyChanged(QString difficulty);
    void terrainChanged(QString terrain);
    void containerChanged(QString container);
    void ownerChanged(QString owner);
    void short_descriptionChanged(QString short_description);
    void long_descriptionChanged(QString long_description);
    void encoded_hintsChanged(QString encoded_hints);
    void lastFoundChanged(QString lastFound);
    void distanceChanged(qreal distance);
    void bearingChanged(qreal bearing);
    void navigateStartChanged(int navigateStart);
    void navigateEndChanged(int navigateEnd);
    void searchStartChanged(int searchStart);
    void searchEndChanged(int searchEnd);

private:
    QString name;
    QString gsname;
    qreal   lat;
    qreal   lon;
    QString time;
    QString type;
    qreal   difficulty;
    qreal   terrain;
    QString container;
    QString owner;
    QString short_description;
    QString long_description;
    QString encoded_hints;
    QString lastFound;
    qreal   distance = -1;
    qreal   bearing = -1;
    int     navigateStart = 0;
    int     navigateEnd = 0;
    int     searchStart = 0;
    int     searchEnd = 0;

public slots:
    void setName(QString name) { this -> name = name; qDebug() << "Cache(" << this << ")::setName(" << this -> name << ")"; }
    QString getName() { qDebug() << "Cache(" << this << ")::getName(): " << this -> name; return this -> name; }

    void setGsname(QString gsname) { this -> gsname = gsname; }
    QString getGsname() { return this -> gsname; }

    void setLat(qreal lat) { this -> lat = lat; }
    qreal getLat() { return this -> lat; }

    void setLon(qreal lon) { this -> lon = lon; }
    qreal getLon() { return this -> lon; }

    void setTime(QString time) { this -> time = time; }
    QString getTime() { return this -> time; }

    void setType(QString type) { this -> type = type; }
    QString getType() { return this -> type; }

    void setDifficulty(qreal difficulty) { this -> difficulty = difficulty; }
    qreal getDifficulty() { return this -> difficulty; }

    void setTerrain(qreal terrain) { this -> terrain = terrain; }
    qreal getTerrain() { return this -> terrain; }

    void setContainer(QString container) { this -> container = container; }
    QString getContainer() { return this -> container; }

    void setOwner(QString owner) { this -> owner = owner; }
    QString getOwner() { return this -> owner; }

    void setShort_description(QString short_description) { this -> short_description = short_description; }
    QString getShort_description() { return this -> short_description; }

    void setLong_description(QString long_description) { this -> long_description = long_description; }
    QString getLong_description() { return this -> long_description; }

    void setEncoded_hints(QString encoded_hints) { this -> encoded_hints = encoded_hints; }
    QString getEncoded_hints() { return this -> encoded_hints; }

    void setLastFound(QString lastFound) { this -> lastFound = lastFound; qDebug() << "   setLastFound(" << this -> lastFound << ")"; }
    QString getLastFound() { return this -> lastFound; }

    void setDistance(qreal distance) { this -> distance = distance; emit distanceChanged(this -> distance); }
    qreal getDistance() { qDebug() << "cache::getDistance():" << this -> distance; return this -> distance; }

    void setBearing(qreal bearing) { this -> bearing = bearing; emit bearingChanged(this -> bearing); }
    qreal getBearing() { return this -> bearing; }

    void setNavigateStart(int navigateStart) { this -> navigateStart = navigateStart; }
    int getNavigateStart() { return this -> navigateStart; }

    void setNavigateEnd(int navigateEnd) { this -> navigateEnd = navigateEnd; }
    int getNavigateEnd() { return this -> navigateEnd; }

    void setSearchStart(int searchStart) { this -> searchStart = searchStart; }
    int getSearchStart() { return this -> searchStart; }

    void setSearchEnd(int searchEnd) { this -> searchEnd = searchEnd; }
    int getSearchEnd() { return this -> searchEnd; }
};
#endif // CACHE_H
