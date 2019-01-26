#ifndef POCKETQUERYDATASOURCE_H
#define POCKETQUERYDATASOURCE_H

#include <QObject>
#include <QFile>
#include <QGeoCoordinate>
#include <QXmlStreamReader>
#include <QDebug>
#include <QQmlEngine>
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
    Q_PROPERTY(QString xmlNamespace READ xmlNamespace WRITE setXmlNamespace NOTIFY xmlNamespaceChanged)

    /* PocketQuery properties */
    Q_PROPERTY(QString name READ name NOTIFY nameChanged)
    Q_PROPERTY(QString time READ time NOTIFY timeChanged)
    // Q_PROPERTY(QVariant bounds READ getBounds NOTIFY boundsChanged)
public:
    explicit PocketQueryDataSource(QObject *parent = nullptr);
    ~PocketQueryDataSource();

    Q_INVOKABLE bool loadCaches(QGeoCoordinate location);

private:
    QString m_xmlNamespace = nullptr;
    QFile   *m_xmlfile = nullptr;
    QXmlStreamReader reader;

    /* PocketQuery properties */
    QString m_name = nullptr;
    QString m_time = nullptr;
    bounds_t m_bounds;

    void readLog(QString *logdata,QString *logtype);
    void readCache(Cache *c);
    void readWpt();
    void readGpx();

signals:
    void xmlNamespaceChanged();
    void nameChanged();
    void timeChanged();
    // void boundsChanged(QGeoCoordinate min,QGeoCoordinate max);

public slots:
    void setXmlNamespace(QString xmlNamespace);
    QString xmlNamespace();

    void setName(QString name);
    QString name();
    void setTime(QString time);
    QString time();
};

#endif // POCKETQUERYDATASOURCE_H
