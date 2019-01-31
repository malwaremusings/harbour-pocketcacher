#include "beeper.h"

Beeper::Beeper(QObject *parent) : QObject(parent)
{
    error = QAudio::NoError;
    bytebuf = new QByteArray();

    qDebug() << "> Beeper::Beep()";
    format.setSampleRate(SAMPLE_RATE);
    format.setChannelCount(1);
    format.setSampleSize(8);
    format.setCodec("audio/pcm");
    format.setByteOrder(QAudioFormat::LittleEndian);
    format.setSampleType(QAudioFormat::UnSignedInt);
    qDebug() << "< Beeper::Beep()";
}

void Beeper::open() {
    this -> audio = new QAudioOutput(format,this);
    qDebug("  State: %d",this -> audio -> state());
    qDebug("  Vol: %f",this -> audio -> volume());
    connect(this -> audio,SIGNAL(stateChanged(QAudio::State)), this, SLOT(handleStateChanged(QAudio::State)));
}

void Beeper::setDuration(qreal duration) {
    this -> bytebuf -> resize(duration * SAMPLE_RATE);
}

void Beeper::setFrequency(qreal freq) {
    /* SAMPLE_RATE is how many bytes of data we have per second of audio */
    /* 1 cycle (Hz) is 360 degrees                                       */
    /* This loop calcs t to be (2PI * freq * (i / SAMPLE_RATE))          */
    /* That is, fit freq number of 360 degrees in to SAMPLE_RATE bytes   */
    /* with each byte being (1 / SAMPLE_RATE)th of the result             */
    for (int i = 0;i < this -> bytebuf -> size();i++) {
        qreal t = (qreal)(freq * i);
        t = t * FREQ_CONST;
        t = qSin(t);
        t *= TG_MAX_VAL;
        (*bytebuf)[i] = quint8(t);
    }

    this -> input.setBuffer(bytebuf);
}

void Beeper::setNote(int note) {
    qreal freq = 440;

    freq = 440 * qPow(1.059463094359295,note);
    qDebug("Beeper::setNote(%d) setting freq to %f",note,freq);
    this->setFrequency(freq);
}

void Beeper::beep() {
    qDebug("> Beeper::beep()\n");
    if (!this) {
        qDebug("    [W] this is null -- expect a crash\n");
    }
    if (!this -> audio) {
        qDebug("    [W] audio is null -- expect a crash\n");
    }

    this -> input.open(QIODevice::ReadOnly);
    this -> audio -> start(&(this -> input));
    qDebug("< Beeper::beep()\n");
}

void Beeper::close() {
    if (audio) delete audio;
}

void Beeper::handleStateChanged(QAudio::State newState) {
    qDebug("> Beeper::handleStateChanged(%d)\n",newState);
    switch(newState) {
        case QAudio::ActiveState:
            qDebug("    ActiveState (%d)\n",newState);
        break;

        case QAudio::IdleState:
            /* Finished */
            qDebug("    IdleState (%d)\n",newState);
            this -> audio -> stop();
            this -> input.close();
        break;

        case QAudio::StoppedState:
            /* Stopped for other reasons */
            qDebug("    StoppedState (%d): %d\n",newState,this -> audio -> error());
            this -> error = audio -> error();
        break;

        default:
            qDebug("    Unhandled state: %d\n",newState);
        break;
    }
    qDebug("< Beeper::handleStateChanged(%d)\n",newState);
}
