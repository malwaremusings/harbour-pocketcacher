#include <QQmlEngine>
#include "pocketquerydatasource.h"
#include "geocachedatasource.h"

PocketQueryDataSource::PocketQueryDataSource(QObject *parent) : GeocacheDataSource(parent)
{
    qDebug() << "PocketQueryDataSource::PocketQueryDataSource(" << parent << ")";
}

PocketQueryDataSource::~PocketQueryDataSource()
{
    qDebug() << "[D] PocketQueryDataSource() destuctor called for " << this;
}

void PocketQueryDataSource::readLog(QString *logdate,QString *logtype) {
    Q_ASSERT(this -> reader.isStartElement() && this -> reader.name() == "log");

    while (this -> reader.readNextStartElement()) {
        // qDebug() << "                log/" << this -> reader.name();

        if (this -> reader.name() == "date") {
            this -> reader.readNext();
            *logdate = this -> reader.text().toString();
            this -> reader.skipCurrentElement();
        } else if (this -> reader.name() == "type") {
            this -> reader.readNext();
            *logtype = this -> reader.text().toString();
            this -> reader.skipCurrentElement();
        } else {
            qDebug() << "  unknown log element: " << this -> reader.name() << "(" << this -> reader.tokenType() << ")";
            this -> reader.skipCurrentElement();
        }
    }
}

void PocketQueryDataSource::readCache(Cache *c) {
    Q_ASSERT(this -> reader.isStartElement() && this -> reader.name() == "cache");

    while (this -> reader.readNextStartElement()) {
        // qDebug() << "            cache/" << this -> reader.name();

        if (this -> reader.name() == "name") {
            this -> reader.readNext();
            c -> setGsname(this -> reader.text().toString());
            this -> reader.skipCurrentElement();
        } else if (this -> reader.name() == "owner") {
            this -> reader.readNext();
            c -> setOwner(this -> reader.text().toString());
            this -> reader.skipCurrentElement();
        } else if (this -> reader.name() == "type") {
            this -> reader.readNext();
            c -> setType(this -> reader.text().toString());
            this -> reader.skipCurrentElement();
        } else if (this -> reader.name() == "container") {
            this -> reader.readNext();
            c -> setContainer(this -> reader.text().toString());
            this -> reader.skipCurrentElement();
        } else if (this -> reader.name() == "difficulty") {
            this -> reader.readNext();
            c -> setDifficulty(this -> reader.text().toFloat());
            this -> reader.skipCurrentElement();
        } else if (this -> reader.name() == "terrain") {
            this -> reader.readNext();
            c -> setTerrain(this -> reader.text().toFloat());
            this -> reader.skipCurrentElement();
        } else if (this -> reader.name() == "short_description") {
            this -> reader.readNext();
            c -> setShort_description(this -> reader.text().toString());
            this -> reader.skipCurrentElement();
        } else if (this -> reader.name() == "long_description") {
            this -> reader.readNext();
            c -> setLong_description(this -> reader.text().toString());
            this -> reader.skipCurrentElement();
        } else if (this -> reader.name() == "encoded_hints") {
            this -> reader.readNext();
            c -> setEncoded_hints(this -> reader.text().toString());
            this -> reader.skipCurrentElement();
        } else if ( this -> reader.name() == "logs") {
            /* iterate through the logs until we find a 'Found it' entry */
            QString logdate = "";

            bool found = false;

            /* need to keep iterating even when found, to read all the <log> tags */
            while (this -> reader.readNextStartElement()) {
                Q_ASSERT(this -> reader.isStartElement() && this -> reader.name() == "log");

                QString logtype;

                readLog(&logdate,&logtype);
                found = found || (logtype == "Found it");
            }

            if (found) {
                c -> setLastFound(logdate);
            } else {
                qDebug() << "    Cache not found";
            }
        } else {
            qDebug() << "  unknown cache element:" << this -> reader.name() << "(" << this -> reader.tokenType() << ")";
            this -> reader.skipCurrentElement();
        }
    }
}

void PocketQueryDataSource::readWpt() {
    Cache *c = nullptr;

    Q_ASSERT(this -> reader.isStartElement() && this -> reader.name() == "wpt");

    c = new Cache();
    // QQmlEngine::setObjectOwnership(&c,QQmlEngine::CppOwnership);

    QXmlStreamAttributes attrs = this -> reader.attributes();
    c -> setLat(attrs.value("lat").toFloat());
    c -> setLon(attrs.value("lon").toFloat());

    while (this -> reader.readNextStartElement()) {
        // qDebug() << "        wpt/" << this -> reader.name() << "(" << this -> reader.tokenType() << ")";

        if (this -> reader.name() == "time") {
            this -> reader.readNext();
            // qDebug() << "Setting time: " << this -> reader.text().toString();
            c -> setTime(this -> reader.text().toString());
            this -> reader.skipCurrentElement();
        } else if (this -> reader.name() == "name") {
            this -> reader.readNext();
            // qDebug() << "Setting name: " << this -> reader.text().toString();
            c -> setName(this -> reader.text().toString());
            this -> reader.skipCurrentElement();
        } else if (this -> reader.name() == "cache") {
            // qDebug() << "Reading cache";
            readCache(c);
        } else {
            this -> reader.skipCurrentElement();
        }
    }

    this -> addCache(c);
}

void PocketQueryDataSource::readGpx() {
    Q_ASSERT(this -> reader.isStartElement() && this -> reader.name() == "gpx");

    while (this -> reader.readNextStartElement()) {
        // qDebug() << "    " << this -> reader.name() << "(" << this -> reader.tokenType() << ")";

        if (this -> reader.name() == "name") {
            this -> reader.readNext();
            this -> setName(this -> reader.text().toString());
            this -> reader.skipCurrentElement();
        } else if (this -> reader.name() == "time") {
            this -> reader.readNext();
            this -> setTime(this -> reader.text().toString());
            this -> reader.skipCurrentElement();
        } else if (this -> reader.name() == "bounds") {
            QXmlStreamAttributes attrs = this -> reader.attributes();
            qreal minlat = 0,minlon = 0;
            qreal maxlat = 0,maxlon = 0;

            for (int i = 0;i < attrs.length();i++) {
                if (attrs[i].name() == "minlat") minlat = attrs[i].value().toFloat();
                if (attrs[i].name() == "minlon") minlon = attrs[i].value().toFloat();
                if (attrs[i].name() == "maxlat") maxlat = attrs[i].value().toFloat();
                if (attrs[i].name() == "maxlon") maxlon = attrs[i].value().toFloat();
            }

            this -> bounds.min = QGeoCoordinate(minlat,minlon);
            this -> bounds.max = QGeoCoordinate(maxlat,maxlon);

            this -> reader.skipCurrentElement();
        } else if (this -> reader.name() == "wpt") {
            readWpt();
        } else {
            this -> reader.skipCurrentElement();
        }
    }
}

bool PocketQueryDataSource::loadCaches()
{
    bool ret = false;

    qDebug() << "> PocketQueryDataSource::loadCaches()";
    qDebug() << "      " << this -> source();
    qDebug() << "      " << this -> source().isValid();
    qDebug() << "      " << this -> source().isLocalFile();

    if (this -> source().isValid() && this -> source().isLocalFile()) {
        this -> setStatus(2);
        this -> xmlfile = new QFile(this -> source().toLocalFile());

        qDebug() << "StartElement == " << QXmlStreamReader::TokenType::StartElement;
        if (this->xmlfile->open(QIODevice::ReadOnly | QIODevice::Text)) {
            this -> reader.setDevice(this -> xmlfile);

            if (this -> reader.readNextStartElement()) {
                if (this -> reader.name() == "gpx") {
                    readGpx();
                    ret = true;
                } else {
                    qDebug() << "Not a GPX file";
                    this -> reader.raiseError(QObject::tr("PocketQuery is not a GPX file"));
                }
            }
        }
        this -> setStatus(3);
        // qDebug() << "    # items in model: " << model() -> size();
    } else {
        qDebug() << "Attempt to read unnamed PocketQuery";
    }

    qDebug() << "< PocketQueryDataSource::loadCaches()";
    return ret;
}