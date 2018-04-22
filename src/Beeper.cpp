#include "Beeper.h"

Beeper::Beeper(QObject *parent) : QObject(parent)
{
    error = QAudio::NoError;
    bytebuf = new QByteArray();

    fprintf(stderr,"> Beeper::Beep()\n");
    format.setSampleRate(SAMPLE_RATE);
    format.setChannelCount(1);
    format.setSampleSize(8);
    format.setCodec("audio/pcm");
    format.setByteOrder(QAudioFormat::LittleEndian);
    format.setSampleType(QAudioFormat::UnSignedInt);
    fprintf(stderr,"< Beeper::Beep()\n");
}

void Beeper::open() {
    this -> audio = new QAudioOutput(format,this);
    fprintf(stderr,"  State: %d\n",this -> audio -> state());
    fprintf(stderr,"  Vol: %f\n",this -> audio -> volume());
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
    fprintf(stderr,"Beeper::setNote(%d) setting freq to %f\n",note,freq);
    this->setFrequency(freq);
}

void Beeper::beep() {
    fprintf(stderr,"> Beeper::beep()\n");
    if (!this) {
        fprintf(stderr,"    [W] this is null -- expect a crash\n");
    }
    if (!this -> audio) {
        fprintf(stderr,"    [W] audio is null -- expect a crash\n");
    }

    this -> input.open(QIODevice::ReadOnly);
    this -> audio -> start(&(this -> input));
    fprintf(stderr,"< Beeper::beep()\n");
}

void Beeper::close() {
    if (audio) delete audio;
}

void Beeper::handleStateChanged(QAudio::State newState) {
    fprintf(stderr,"> Beeper::handleStateChanged(%d)\n",newState);
    switch(newState) {
        case QAudio::ActiveState:
            fprintf(stderr,"    ActiveState (%d)\n",newState);
        break;

        case QAudio::IdleState:
            /* Finished */
            fprintf(stderr,"    IdleState (%d)\n",newState);
            this -> audio -> stop();
            this -> input.close();
        break;

        case QAudio::StoppedState:
            /* Stopped for other reasons */
            fprintf(stderr,"    StoppedState (%d): %d\n",newState,this -> audio -> error());
            this -> error = audio -> error();
        break;

        default:
            fprintf(stderr,"    Unhandled state: %d\n",newState);
        break;
    }
    fprintf(stderr,"< Beeper::handleStateChanged(%d)\n",newState);
}
