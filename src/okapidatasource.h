#ifndef OKAPIDATASOURCE_H
#define OKAPIDATASOURCE_H

#include <QObject>
#include <QDebug>
#include <QQmlEngine>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QJsonObject>
#include "geocachedatasource.h"
#include "cachernetworkaccessmanager.h"
// #include "resttransaction.h"

class OKAPIDataSource : public GeocacheDataSource
{
    Q_OBJECT

    Q_PROPERTY(QString consumerKey READ consumerKey WRITE setConsumerKey)
    Q_PROPERTY(QNetworkAccessManager *network READ network WRITE setNetwork)
    Q_PROPERTY(QString host READ host WRITE setHost NOTIFY hostChanged)

public:
    OKAPIDataSource(QObject *parent = nullptr);

    Q_INVOKABLE QString consumerKey();
    Q_INVOKABLE void setConsumerKey(QString consumerKey);

    Q_INVOKABLE QNetworkAccessManager *network();
    Q_INVOKABLE void setNetwork(QNetworkAccessManager *network);

    Q_INVOKABLE QString host();
    Q_INVOKABLE void setHost(QString host);

    Q_INVOKABLE bool searchCaches();
    Q_INVOKABLE bool loadCaches();

private:
    QString m_consumerKey;
    QNetworkAccessManager *m_network;
    QString m_host;
    QNetworkReply *m_reply;

signals:
    // void jsonCompleted(QJsonArray json);
    void loadCompleted(QVariantMap json);
    void hostChanged(QString host);

private slots:
    void searchCompleted();
};

#endif // OKAPIDATASOURCE_H
