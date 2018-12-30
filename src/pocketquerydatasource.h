#ifndef POCKETQUERYDATASOURCE_H
#define POCKETQUERYDATASOURCE_H

#include <QObject>
#include <QFile>
#include <QGeoCoordinate>
#include <QXmlStreamReader>
#include <QDebug>
#include "geocachedatasource.h"
#include "cache.h"
// #include "cachelistmodel.h"
// #include "cachemodel.h.dontuse"

typedef struct bounds_struct {
    QGeoCoordinate min;
    QGeoCoordinate max;
} bounds_t;

class PocketQueryDataSource : public GeocacheDataSource
{
    Q_OBJECT
    Q_PROPERTY(QString xmlnamespace READ getXmlNamespace WRITE setXmlNamespace NOTIFY xmlNamespaceChanged)
    Q_PROPERTY(int status READ getStatus NOTIFY statusChanged)

    /* PocketQuery properties */
    Q_PROPERTY(QString name READ getName NOTIFY nameChanged)
    Q_PROPERTY(QString time READ getTime NOTIFY timeChanged)
    // Q_PROPERTY(QVariant bounds READ getBounds NOTIFY boundsChanged)
public:
    explicit PocketQueryDataSource(QObject *parent = nullptr);
    ~PocketQueryDataSource();

    Q_INVOKABLE bool loadCaches();

private:
    QString xmlnamespace = nullptr;
    int     status = 0;
    QFile   *xmlfile = nullptr;
    QXmlStreamReader reader;

    /* PocketQuery properties */
    QString name = nullptr;
    QString time = nullptr;
    bounds_t bounds;

signals:
    void xmlNamespaceChanged(QString xmlnamespace);
    void statusChanged(int status);
    void nameChanged(QString name);
    void timeChanged(QString time);
    // void boundsChanged(QGeoCoordinate min,QGeoCoordinate max);

public slots:
    void setXmlNamespace(QString xmlnamespace) { qDebug() << "setXmlNamespace(" << xmlnamespace << ")"; this -> xmlnamespace = xmlnamespace; }
    QString getXmlNamespace() { qDebug() << "getXmlNamespace(): " << this -> xmlnamespace; return this -> xmlnamespace; }

    int getStatus() { qDebug() << "getStatus(): " << this -> status; return this -> status; }

    void setName(QString name) { qDebug() << "setName(" << name << ")"; this -> name = name; }
    QString getName() { qDebug() << "getName(): " << this -> name; return this -> name; }
    void setTime(QString time) { qDebug() << "setTime(" << time << ")"; this -> time = time; }
    QString getTime() { qDebug() << "getTime(): " << this -> time; return this -> time; }

    void readLog(QString *logdata,QString *logtype);
    void readCache(Cache *c);
    void readWpt();
    void readGpx();
};

#endif // POCKETQUERYDATASOURCE_H
