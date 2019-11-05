import QtQuick 2.6
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.12
import ".."

ProgressBar {
    id: control
    value: 0.5
    padding: 0

    property alias color :  progress.color

    background: Rectangle {
        implicitWidth: 200
        height: Units.dp(4)
        color: Qt.darker(progress.color,1.8)
        radius: height/2
        opacity: 0.2
    }

    contentItem: Item {
        implicitWidth: 200
        height: Units.dp(4)

        Rectangle {
            id:progress
            width: control.visualPosition * parent.width
            height: Units.dp(4)
            radius: height/2
            color: ConstList_Color.accentGreen
        }
    }
}
