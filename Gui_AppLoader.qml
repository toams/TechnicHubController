import QtQuick 2.0
import QtQuick.Window 2.11
import QtGraphicalEffects 1.0
import QtQuick.Controls.Material 2.2

Item {
    id:root
    width: Screen.width
    height: Screen.height

    property bool dark: appSett.getDarkMode()

    Rectangle {
        id: background
        color: dark ? Style.dark_background : Style.light_background
        anchors.fill: parent
    }

    Rectangle {
        id: line
        height: loader.height/30
        color: dark ? Style.dark_accent : Style.light_accent
        radius: height/2
        anchors.top: loader.bottom
        anchors.topMargin: 0
        anchors.rightMargin: -loader.width/4
        anchors.leftMargin: -loader.width/4
        anchors.right: loader.right
        anchors.left: loader.left
        layer.effect: DropShadow {
            radius: 4
            color:Style.dark_background
        }
        layer.enabled: true
    }

    Rectangle {
        id: whiteLine
        x: startX
        y: line.y + 4
        width: line.width/4
        height: loader.height/30
        color: dark ? Style.dark_foreground : Style.light_foreground
        radius: height/2
        layer.effect: DropShadow {
            radius: 4
            color:Style.dark_background
        }
        layer.enabled: true

        property int startX: (line.x + line.width) + whiteLine.width
        property int stopX: line.x - whiteLine.width
    }

    Item {
        id: loader
        y: centerY
        width: 80
        height: width
        anchors.horizontalCenter: parent.horizontalCenter

        property int centerY: root.height/2 - loader.height/2

        Rectangle {
            id: backgroundRectangle
            color: dark ? Style.dark_control_background : Style.light_control_background
            radius: height/2
            border.width: loader.height/30
            border.color: dark ? Style.dark_control_border : Style.light_control_border
            anchors.fill: parent
            layer.effect: DropShadow {
                radius: 4
                color:Style.dark_background
            }
            layer.enabled: true
        }

        Rectangle {
            id: rectangle
            x: -220
            y: 92
            height: backgroundRectangle.border.width
            color: backgroundRectangle.border.color
            radius: height/2
            border.width: 0
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.verticalCenter: parent.verticalCenter
        }

        Rectangle {
            id: steeringPoint
            x: 38
            y: 38
            width: loader.height/2.2
            height: width
            color: dark ? Style.dark_control_primary : Style.light_control_primary
            radius: height/2
            border.width: loader.height/30
            border.color: dark ? Style.dark_control_border : Style.light_control_border
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            layer.enabled: false
            layer.effect: DropShadow{
                radius:8
            }
        }

        ParallelAnimation{
            id:loaderAniamtionSpin
            running: true
            PropertyAnimation{
                target:loader
                property: "rotation"
                from:0
                to:180
                duration: 400
            }
            loops: Animation.Infinite
        }

        ParallelAnimation{
            running: true
            id:roadlineAniamtion
            SequentialAnimation{
                PropertyAnimation{
                    target:whiteLine
                    property: "x"
                    from:whiteLine.startX
                    to:whiteLine.stopX
                    duration: 400
                }
                NumberAnimation{
                    duration: 600
                }
            }
            SequentialAnimation{
                PropertyAnimation{
                    target:whiteLine
                    property: "opacity"
                    from:0
                    to:1
                    duration: 200
                }
                PropertyAnimation{
                    target:whiteLine
                    property: "opacity"
                    from:1
                    to:0
                    duration: 200
                }
            }
            loops: Animation.Infinite
        }

        SequentialAnimation{
            id:loaderAniamtionJump
            PropertyAnimation{
                target:loader
                property: "y"
                to:loader.centerY - 50
                duration: 400
                easing.type: Easing.InCubic
            }
            PropertyAnimation{
                target:loader
                property: "y"
                to:loader.centerY
                duration: 400
                easing.type: Easing.OutCubic
            }
            NumberAnimation{
                duration: 900
            }
            loops: Animation.Infinite
        }

    }

    Item {
        id: appName
        anchors.top: parent.top
        anchors.topMargin: 0
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.bottom: parent.verticalCenter
        anchors.bottomMargin: 0

        Text {
            id: text1
            color: dark ? Style.dark_foreground : Style.light_foreground
            text: "Contro1z"
            verticalAlignment: Text.AlignTop
            font.family: Style.logoFont
            font.weight: Font.Light
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 80
        }
    }

}
