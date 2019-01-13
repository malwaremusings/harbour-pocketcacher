#ifndef CACHERSATELLITEINFOSOURCE_H
#define CACHERSATELLITEINFOSOURCE_H

#include <QObject>
#include <QGeoSatelliteInfoSource>
#include <QDebug>

class CacherSatelliteInfoSource : public QObject
{
    Q_OBJECT

    Q_PROPERTY(int updateInterval READ updateInterval WRITE setUpdateInterval NOTIFY updateIntervalChanged)
    Q_PROPERTY(bool active READ active WRITE setActive NOTIFY activeChanged)
    Q_PROPERTY(int numSatellitesInView READ numSatellitesInView NOTIFY numSatellitesInViewChanged)
    Q_PROPERTY(int numSatellitesInUse READ numSatellitesInUse NOTIFY numSatellitesInUseChanged)

public:
    explicit CacherSatelliteInfoSource(QObject *parent = nullptr);

    Q_INVOKABLE int updateInterval();
    Q_INVOKABLE void setUpdateInterval(int updateInterval);
    Q_INVOKABLE bool active();
    Q_INVOKABLE void setActive(bool active);
    Q_INVOKABLE int numSatellitesInView();
    Q_INVOKABLE int numSatellitesInUse();

private:
    QGeoSatelliteInfoSource *m_source;
    bool m_active;
    QList<QGeoSatelliteInfo> m_satellitesInView;
    int m_numSatellitesInView = 0;
    QList<QGeoSatelliteInfo> m_satellitesInUse;
    int m_numSatellitesInUse = 0;

signals:
    // void satellitesInViewChanged(const QList<QGeoSatelliteInfo> &satellites);
    // void satellitesInUseChanged(const QList<QGeoSatelliteInfo> &satellites);
    void numSatellitesInViewChanged(const int numSatellites);
    void numSatellitesInUseChanged(const int numSatellites);
    void updateIntervalChanged();
    void activeChanged();

public slots:
    void satellitesInViewUpdated(const QList<QGeoSatelliteInfo> &satellites);
    void satellitesInUseUpdated(const QList<QGeoSatelliteInfo> &satellites);
};

#endif // CACHERSATELLITEINFOSOURCE_H
