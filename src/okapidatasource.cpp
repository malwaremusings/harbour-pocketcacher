#include "okapidatasource.h"

OKAPIDataSource::OKAPIDataSource(QObject *parent) : GeocacheDataSource(parent)
{
    qDebug() << "PocketQueryDataSource::PocketQueryDataSource(" << parent << ")";
}

QString OKAPIDataSource::consumerKey()
{
    return m_consumerKey;
}

void OKAPIDataSource::setConsumerKey(QString consumerKey)
{
    qDebug() << "OKAPIDataSource::setConsumerKey(" << consumerKey << ")";
    m_consumerKey = consumerKey;
}

QNetworkAccessManager *OKAPIDataSource::network()
{
    return m_network;
}

void OKAPIDataSource::setNetwork(QNetworkAccessManager *network)
{
    m_network = network;
}

QString OKAPIDataSource::host()
{
    return m_host;
}

void OKAPIDataSource::setHost(QString host)
{
    if (host != m_host) {
        m_host = host;
        emit hostChanged(m_host);
    }
}

bool OKAPIDataSource::searchCaches(QGeoCoordinate location)
{
    bool ret = false;

    if (m_network) {
#if 0
        qint64 now = QDateTime::currentMSecsSinceEpoch();
        double lat_fudge = ((now / 10000000000) + (now % 2000) - 1000);
        double lat = location.latitude() + lat_fudge;

        now = QDateTime::currentMSecsSinceEpoch();
        double lon_fudge = ((now / 10000000000) + (now % 2000) - 1000);
        double lon = location.longitude() + lon_fudge;
#endif

        QString urlStr = "https://" + m_host + "/okapi/services/caches/shortcuts/search_and_retrieve?consumer_key=" + m_consumerKey + "&search_method=services/caches/search/nearest&search_params={\"center\":\"" + QString::number(location.latitude()) + "|" + QString::number(location.longitude()) + "\"}&radius=100&retr_method=services/caches/geocaches&retr_params={\"fields\":\"code|name|location|type|status|owner|size2|difficulty|terrain|short_description|description|hint2|last_found|date_created\"}&wrap=false";
        qDebug() << "    requesting url: " << urlStr;

        // urlStr = "https://" + m_host + "/okapi/services/caches/shortcuts/search_and_retrieve?consumer_key=" + m_consumerKey + "&search_method=services/caches/search/nearest&search_params={\"center\":\"" + QString::number(lat) + "|" + QString::number(lon) + "\"}&radius=100&retr_method=services/caches/geocaches&retr_params={\"fields\":\"code|name|location|type|status|owner|size2|difficulty|terrain|short_description|description|hint2|last_found|date_created\"}&wrap=false";
        // qDebug() << "    requesting url: " << urlStr;
        m_reply = m_network -> get(QNetworkRequest(QUrl(urlStr)));
        connect(m_reply,&QNetworkReply::finished,this,&OKAPIDataSource::searchCompleted);

        ret = true;
    }

    return ret;
}

bool OKAPIDataSource::loadCaches(QGeoCoordinate location)
{
    qDebug() << "OKAPIDataSource::loadCaches()";
    searchCaches(location);

    return false;
}

void OKAPIDataSource::searchCompleted()
{
    qDebug() << "OKAPIDataSource::requestCompleted()";

    QByteArray jsonText = m_reply -> readAll();
    m_reply->deleteLater();

    QJsonDocument jDoc = QJsonDocument::fromJson(jsonText);
    QVariantMap jObject = jDoc.object().toVariantMap();

    /* add returned caches to model */
    // qDebug() << "  Iterating:";

    QVariantMap::const_iterator end = jObject.end();
    for (QVariantMap::const_iterator i = jObject.begin(); i != end; i++) {
        QVariantMap cacheProperties = i.value().toMap();

        QString location = cacheProperties.value("location").toString();
        QStringList latlon = location.split('|');
        QString lat = latlon[0];
        QString lon = latlon[1];

#if 0
        qDebug() << "    " << i.key() << ": " << i.value();
        qDebug() << "        code: " << cacheProperties.value("code").toString();
        qDebug() << "        name: " << cacheProperties.value("name").toString();
        qDebug() << "        type: " << cacheProperties.value("type").toString();
        qDebug() << "        status: " << cacheProperties.value("status").toString();
        qDebug() << "        location: " << location;
        qDebug() << "            lat: " << lat;
        qDebug() << "            lon: " << lon;
#endif

        QVariantMap ownerMap = cacheProperties.value("owner").toMap();

        Cache *c = new Cache();

        /*
         * Stop Caches from being destroyed after viewing them.
         * This seems like a kludge -- i wonder if it is the correct way to solve
         * this problem or if i should be using something like QSharedPointer<>
         * or redesiging the code.
         */
        QQmlEngine::setObjectOwnership(c,QQmlEngine::CppOwnership);

        c -> setName(cacheProperties.value("code").toString());
        c -> setGsname(cacheProperties.value("name").toString());
        c -> setLat(lat.toFloat());
        c -> setLon(lon.toFloat());
        c -> setTime(cacheProperties.value("date_created").toString());
        c -> setType(cacheProperties.value("type").toString());
        c -> setDifficulty(cacheProperties.value("difficulty").toReal());
        c -> setTerrain(cacheProperties.value("terrain").toReal());
        c -> setContainer(cacheProperties.value("size2").toString());
        c -> setOwner(ownerMap.value("username").toString());
        c -> setShort_description(cacheProperties.value("short_description").toString());
        c -> setLong_description(cacheProperties.value("description").toString());
        c -> setEncoded_hints(cacheProperties.value("hint2").toString());
        c -> setLastFound(cacheProperties.value("last_found").toString());

        this -> addCache(c);
    }
}
