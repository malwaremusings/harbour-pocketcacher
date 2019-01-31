#ifndef BEEPER_H
#define BEEPER_H

#include <QObject>
#include <QQuickItem>
#include <QBuffer>
#include <QAudio>
#include <QAudioFormat>
#include <QAudioOutput>
#include <QtMath>
#include <QDebug>

#define SAMPLE_RATE 8000
#define FREQ_CONST ((2.0 * M_PI) / SAMPLE_RATE)
#define TG_MAX_VAL 15

class Beeper : public QObject
{
    Q_OBJECT
public:
    QAudio::Error error = QAudio::NoError;

    explicit Beeper(QObject *parent = nullptr);
    Q_INVOKABLE void open();
    Q_INVOKABLE void setDuration(qreal duration);
    Q_INVOKABLE void setFrequency(qreal freq);
    Q_INVOKABLE void setNote(int note);
    Q_INVOKABLE void beep();
    Q_INVOKABLE void close();

signals:

public slots:
    void handleStateChanged(QAudio::State newState);

private:
    QAudioFormat format;
    QByteArray   *bytebuf;
    QAudioOutput *audio;
    QBuffer      input;
};

#endif // BEEPER_H
