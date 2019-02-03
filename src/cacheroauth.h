#ifndef CACHEROAUTH_H
#define CACHEROAUTH_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QUrl>
#include <QCryptographicHash>
#include <QMessageAuthenticationCode>
#include <QUrlQuery>

class CacherOAuth : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QNetworkAccessManager *network READ network WRITE setNetwork)
    Q_PROPERTY(QString host READ host WRITE setHost NOTIFY hostChanged)
    Q_PROPERTY(QString token READ token WRITE setToken NOTIFY tokenChanged)
    Q_PROPERTY(QString tokenSecret READ tokenSecret WRITE setTokenSecret)

public:
    explicit CacherOAuth(QObject *parent = nullptr);

    Q_INVOKABLE QNetworkAccessManager *network();
    Q_INVOKABLE void setNetwork(QNetworkAccessManager *network);
    Q_INVOKABLE QString host();
    Q_INVOKABLE void setHost(QString host);
    Q_INVOKABLE QString token();
    Q_INVOKABLE void setToken(QString token);
    Q_INVOKABLE QString tokenSecret();
    Q_INVOKABLE void setTokenSecret(QString tokenSecret);

    Q_INVOKABLE void authorise(QString hostname, QObject *webView);

private:
#include "okapikeys.h"
    QNetworkAccessManager *m_network;
    QString m_host;
    QString m_token = "";
    QString m_tokenSecret = "";
    QObject *m_webView;

    QNetworkReply *m_requestTokenReply;
    QNetworkReply *m_accessTokenReply;

    void _request_token();
    void _authorise();
    void _access_token();
    QString _sign(QString oauthUrl,QMap<QString, QString> &oauthArgs);

    QString paramsToEncodedString(QMap<QString,QString> params);

signals:
    void consumerKeyChanged();
    void hostChanged();
    void tokenChanged();
    void accessTokenChanged();

public slots:
    void requestTokenCompleted();
    void redirect(QString redirectUrl);
    void accessTokenCompleted();
};

#endif // CACHEROAUTH_H
