import QtQuick 2.0
import QtQuick.Controls.Material 2.2
import QtGraphicalEffects 1.0

import ".."
import "qrc:/Controls"

Parent{
    id:root

    height:width

    Component.onCompleted:{
        requiredParameters.ports = true;
        requiredParameters.inversion = true;
        requiredParameters.servoangle = true;
    }

    property int minWidth: Units.dp(150)
    property int maxWidth: Units.dp(190)

    onSizeMinusClicked: {
        if(width > minWidth) {

            width -= Units.dp(10);
            height = width;
        }
        touchPoint.x = root.width/2 - touchPoint.width/2
    }

    onSizePlusClicked: {
        if(width < maxWidth) {

            width += Units.dp(10);
            height = width;
        }
        touchPoint.x = root.width/2 - touchPoint.width/2
    }

    property int angle:0

    onTouchPressed: {
        vibrate("middle");
        angleReady(calcAngle(x));
    }

    onTouchReleased: {
        touchPointToCenter.start();
    }

    onTouchUpdated: {
        var an = calcAngle(x);
        if(an % 10 == 0){
            angleReady(an);
        }
        if(an % 10 == 0 && an > -servoangle && an < servoangle){
            vibrate("weak");
        }
    }

    function calcAngle(x){
        if(x < touchPoint.width/2) x = (touchPoint.width/2);
        if(x > root.width - touchPoint.width/2) x = (root.width - touchPoint.width/2);
        touchPoint.x = x-touchPoint.width/2;
        var an = Math.round(servoangle * 2/(root.width-touchPoint.width)*(x - root.width/2));
        root.angle = an;
        return an;
    }

    function angleReady(angle){
        cpp_Controller.rotateMotor(inverted? -angle: angle, chAddress, ports[0], ports[1], ports[2], ports[3]);
    }

    function vibrate(force){
        if(root.parent.taptic){

            if(force === "middle"){
                cpp_Android.vibrateMiddle();
            }
            else cpp_Android.vibrateWeak();

        }
    }

    Item {
        id: angleArrowItem
        width: root.width
        height: width
        rotation: root.angle

        Rectangle {
            id: angleArrow
            width: parent.width/8
            height: width
            color: Material.accent
            anchors.topMargin: -height/2.5
            rotation: 45
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
        }

        Behavior on rotation {
            NumberAnimation{
                duration: 100
            }
        }
    }

    CustomCircle{
        id:background
        anchors.fill: parent
        borderWidth: Units.dp(6)
        borderColor: ConstList_Color.controls_border_color
    }

    Rectangle {
        id: rectangle
        color: Material.accent
        radius: height/2
        anchors.fill: parent
        anchors.margins: background.borderWidth
        opacity: Math.abs(root.angle * 1.1)/100

        Behavior on color{
            ColorAnimation {
                duration: 200
            }
        }
    }

    Rectangle {
        id: directionLine
        height: root.height/14
        color: ConstList_Color.controls_border_color
        radius: height/2
        anchors.right: parent.right
        anchors.rightMargin: Units.dp(18)
        anchors.left: parent.left
        anchors.leftMargin: Units.dp(18)
        anchors.verticalCenter: parent.verticalCenter
    }


    CustomCircle{
        id:touchPoint
        x: root.width/2 - width/2
        width: root.height/2.5
        height: width
        anchors.verticalCenter: parent.verticalCenter
        borderWidth: Units.dp(8)
        borderColor: ConstList_Color.controls_border_color
        elevationValue: 8
        color: Qt.darker(Material.primary, 1.05)
        z: 0

        ParallelAnimation{
            id:touchPointToCenter
            PropertyAnimation{
                target:touchPoint
                property:"x"
                to: root.width/2 - touchPoint.width/2
                duration: 100
            }
            PropertyAnimation{
                target:angleArrowItem
                property:"rotation"
                to: 0
                duration: 100
            }
            onStopped: {
                root.angleReady(0);
                root.angle = 0;
            }
        }

        Item {
            id: gripItem
            width: parent.height/3
            height: width
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter

            Rectangle {
                id: grip1
                width: touchPoint.borderWidth/2
                color: touchPoint.borderColor
                radius: width/2
                anchors.left: parent.left
                anchors.leftMargin: 0
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0
                anchors.top: parent.top
                anchors.topMargin: 0
                layer.enabled: true
                layer.effect: DropShadow{
                    radius: Units.dp(3)
                    samples: Units.dp(6)
                    color: "#7F000000"
                }
            }

            Rectangle {
                id: grip2
                width: touchPoint.borderWidth/2
                color: touchPoint.borderColor
                radius: width/2
                anchors.right: parent.right
                anchors.rightMargin: 0
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0
                anchors.top: parent.top
                anchors.topMargin: 0
                layer.enabled: true
                layer.effect: DropShadow{
                    radius: Units.dp(3)
                    samples: Units.dp(6)
                    color: "#7F000000"
                }
            }

            Rectangle {
                id: grip3
                width: touchPoint.borderWidth/2
                color: touchPoint.borderColor
                radius: width/2
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0
                anchors.top: parent.top
                anchors.topMargin: 0
                layer.enabled: true
                layer.effect: DropShadow{
                    radius: Units.dp(3)
                    samples: Units.dp(6)
                    color: "#7F000000"
                }
            }
        }

    }


}
