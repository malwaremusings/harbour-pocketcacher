#ifndef CACHELISTMODEL_H
#define CACHELISTMODEL_H

#include <QObject>

class CacheListModel : public QObject
{
    Q_OBJECT
public:
    explicit CacheListModel(QObject *parent = nullptr);

signals:

public slots:
};

#endif // CACHELISTMODEL_H