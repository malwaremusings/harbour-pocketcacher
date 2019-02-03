#include "cacheroauth.h"

CacherOAuth::CacherOAuth(QObject *parent) : QObject(parent)
{

}

QNetworkAccessManager *CacherOAuth::network()
{
    return m_network;
}

void CacherOAuth::setNetwork(QNetworkAccessManager *network)
{
    m_network = network;
}

QString CacherOAuth::host()
{
    return m_host;
}

void CacherOAuth::setHost(QString host)
{
    if (host != m_host) {
        m_host = host;
        emit hostChanged();
    }
}

QString CacherOAuth::token()
{
    return m_token;
}

void CacherOAuth::setToken(QString token)
{
    if (m_token != token) {
        m_token = token;
        emit tokenChanged();
    }
}

QString CacherOAuth::tokenSecret()
{
    return m_tokenSecret;
}

void CacherOAuth::setTokenSecret(QString tokenSecret)
{
    m_tokenSecret = tokenSecret;
}

void CacherOAuth::_request_token()
{
    /* send network request for a request token */

    QMap<QString,QString> params;

    QString urlStr = "https://" + m_host + "/okapi/services/oauth/request_token";
    QNetworkRequest url = QNetworkRequest(urlStr);
    url.setHeader(QNetworkRequest::ContentTypeHeader,"application/x-www-form-urlencoded");

    _sign(urlStr,params);

    QByteArray postStr = QByteArray::fromStdString(paramsToEncodedString(params).toStdString());

    m_requestTokenReply = m_network -> post(url,postStr);
    connect(m_requestTokenReply,&QNetworkReply::finished,this,&CacherOAuth::requestTokenCompleted);
}

void CacherOAuth::_authorise()
{
    m_webView -> setProperty("url","https://" + m_host + "/okapi/services/oauth/authorize?oauth_token=" + m_token);
}

QString CacherOAuth::_sign(QString oauthUrl,QMap<QString, QString> &oauthArgs)
{
    quint64 now = QDateTime::currentMSecsSinceEpoch();
    oauthArgs["oauth_callback"] = "pocketcacher://oauth_callback";
    oauthArgs["oauth_consumer_key"] = consumerKey(m_host);
    oauthArgs["oauth_nonce"] = QCryptographicHash::hash(QString::number(now).toUtf8(), QCryptographicHash::Md5).toHex();
    oauthArgs["oauth_signature_method"] = "HMAC-SHA1";
    oauthArgs["oauth_timestamp"] = QString::number(now / 1000);
    oauthArgs["oauth_version"] = "1.0";

    QString toSign = "POST&" + QUrl::toPercentEncoding(oauthUrl) + "&" + QUrl::toPercentEncoding(paramsToEncodedString(oauthArgs));

    QByteArray keys = QUrl::toPercentEncoding(consumerSecret(m_host)) + "&" + QUrl::toPercentEncoding(m_tokenSecret);
    QString signature = QMessageAuthenticationCode::hash(toSign.toUtf8(), keys, QCryptographicHash::Sha1).toBase64();
    oauthArgs["oauth_signature"] = signature;

    return signature;
}

QString CacherOAuth::paramsToEncodedString(QMap<QString, QString> params)
{
    QString ret;

    QMap<QString,QString>::const_iterator end = params.constEnd();

    for (QMap<QString,QString>::const_iterator i = params.constBegin(); i != end; i++) {
        QString paramstr = i.key() + "=" + QUrl::toPercentEncoding(i.value());
        ret += (ret != "")?"&":"";
        ret += (paramstr);
    }

    return ret;
}

void CacherOAuth::requestTokenCompleted()
{
    QString qryStr = m_requestTokenReply -> readAll();
    m_requestTokenReply -> deleteLater();

    QUrlQuery qry = QUrlQuery(qryStr);

    setTokenSecret(qry.queryItemValue("oauth_token_secret"));
    setToken(qry.queryItemValue("oauth_token"));

    if (tokenSecret() != "" && token() != "") {
        _authorise();
    }
}

void CacherOAuth::redirect(QString redirectUrl)
{
    if (redirectUrl.startsWith("pocketcacher://oauth_callback")) {
        QUrl u = QUrl(redirectUrl);
        QUrlQuery qry = QUrlQuery(u.query());
        QString oauth_token = qry.queryItemValue("oauth_token");
        QString oauth_verifier = qry.queryItemValue("oauth_verifier");

        QMap<QString,QString> params;
        params["oauth_token"] = oauth_token;
        params["oauth_verifier"] = oauth_verifier;

        QString urlStr = "https://" + m_host + "/okapi/services/oauth/access_token";
        QNetworkRequest url = QNetworkRequest(urlStr);
        url.setHeader(QNetworkRequest::ContentTypeHeader,"application/x-www-form-urlencoded");

        _sign(urlStr,params);

        QByteArray postStr = QByteArray::fromStdString(paramsToEncodedString(params).toStdString());

        m_accessTokenReply = m_network -> post(url,postStr);
        connect(m_accessTokenReply,&QNetworkReply::finished,this,&CacherOAuth::accessTokenCompleted);
    }
}

void CacherOAuth::accessTokenCompleted()
{
    QString qryStr = m_accessTokenReply -> readAll();
    m_accessTokenReply -> deleteLater();

    QUrlQuery qry = QUrlQuery(qryStr);

    setTokenSecret(qry.queryItemValue("oauth_token_secret"));
    setToken(qry.queryItemValue("oauth_token"));

    emit accessTokenChanged();
}

void CacherOAuth::authorise(QString hostname,QObject *webView) {
    m_webView = webView;
    setHost(hostname);
    _request_token();
}
