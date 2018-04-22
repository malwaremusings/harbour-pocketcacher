import QtQuick 2.2
import Sailfish.Silica 1.0
import QtPositioning 5.3

Item {
    property QtPositioning.coordinate coordinate
    property string name
    property string gsname
    property string type
    property real   difficulty
    property real   terrain
    property string container
    property string owner
    property string short_description
    property string long_description
    property string last_log

    property real   navigateStart
    property real   navigateEnd
    property real   searchStart
    property real   searchEnd
}
