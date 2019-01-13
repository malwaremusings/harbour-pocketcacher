#include "cachersatelliteinfosource.h"

CacherSatelliteInfoSource::CacherSatelliteInfoSource(QObject *parent) : QObject(parent)
{
    m_source = QGeoSatelliteInfoSource::createDefaultSource(0);
    connect(m_source,SIGNAL(satellitesInViewUpdated(QList<QGeoSatelliteInfo>)),this,SLOT(satellitesInViewUpdated(QList<QGeoSatelliteInfo>)));
    connect(m_source,SIGNAL(satellitesInUseUpdated(QList<QGeoSatelliteInfo>)),this,SLOT(satellitesInUseUpdated(QList<QGeoSatelliteInfo>)));
}

int CacherSatelliteInfoSource::updateInterval()
{
    return m_source -> updateInterval();
}

void CacherSatelliteInfoSource::setUpdateInterval(int updateInterval)
{
    m_source -> setUpdateInterval(updateInterval);
    emit updateIntervalChanged();
}

bool CacherSatelliteInfoSource::active()
{
    return m_active;
}

void CacherSatelliteInfoSource::setActive(bool active)
{
    if (m_active != active) {
        m_active = active;
        if (active) {
            m_source -> startUpdates();
        } else {
            m_source -> stopUpdates();
        }
        emit activeChanged();
    }
}

int CacherSatelliteInfoSource::numSatellitesInView()
{
    return m_numSatellitesInView;
}

int CacherSatelliteInfoSource::numSatellitesInUse()
{
    return m_numSatellitesInUse;
}

void CacherSatelliteInfoSource::satellitesInViewUpdated(const QList<QGeoSatelliteInfo> &satellites)
{
    m_satellitesInView = satellites;
    if (m_satellitesInView.length() != m_numSatellitesInView) {
        m_numSatellitesInView = m_satellitesInView.length();
        emit numSatellitesInViewChanged(m_numSatellitesInView);
    }
}

void CacherSatelliteInfoSource::satellitesInUseUpdated(const QList<QGeoSatelliteInfo> &satellites)
{
    m_satellitesInUse = satellites;
    if (m_satellitesInUse.length() != m_numSatellitesInUse) {
        m_numSatellitesInUse = m_satellitesInUse.length();
        emit numSatellitesInUseChanged(m_satellitesInUse.length());
    }
}
