import QtQuick 2.0
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2

Profile_Control_Parent {
    id:root
    width:120
    height: width/2

    property int speed: 100

    Rectangle {
        id: rectangle
        color: "#302f2f"
        radius: height/2
        anchors.fill: parent
        layer.enabled: false
        layer.effect: DropShadow{
            radius:8
        }
    }

    Rectangle {
        id: reverseButton
        width: root.height
        height: width
        color: "#474646"
        radius: height/2
        anchors.top: parent.top
        anchors.topMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        border.width: root.height/20
        border.color: "#302f2f"

        Behavior on border.width{
            NumberAnimation{
                duration: 200
            }
        }

        Behavior on color{
            ColorAnimation{
                duration: 500
            }
        }

        MultiPointTouchArea{
            id: mouseArea
            anchors.fill: parent

            onPressed: {
                reverseButton.border.width = root.height/8
                reverseButton.color = Qt.lighter("#474646", 1.2)
                var spd = inverted ? speed : - speed;
                hubOperator.motor_RunPermanent(port, spd)
            }
            onReleased: {
                reverseButton.border.width = root.height/20
                reverseButton.color = "#474646"
                hubOperator.motor_RunPermanent(port, 0)
            }
        }

        Image {
            id: image1
            width: 26
            height: width
            opacity: 0.5
            fillMode: Image.PreserveAspectFit
            source: "icons/anticlockwise.svg"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            ColorOverlay{
                source: image1
                color: Style.dark_foreground
                opacity: 1
                anchors.fill: parent
            }
        }
    }

    Rectangle {
        id: forwardButton
        x: -6
        width: root.height
        height: width
        color: "#474646"
        radius: height/2
        anchors.top: parent.top
        anchors.topMargin: 0
        anchors.right: parent.right
        anchors.rightMargin: 0
        border.color: "#302f2f"
        border.width: root.height/20

        Behavior on border.width{
            NumberAnimation{
                duration: 200
            }
        }

        Behavior on color{
            ColorAnimation{
                duration: 500
            }
        }

        MultiPointTouchArea{
            id: mouseArea1
            anchors.fill: parent
            onPressed: {
                forwardButton.border.width = root.height/8
                forwardButton.color = Qt.lighter("#474646", 1.4)
                var spd = inverted ? -speed : speed;
                hubOperator.motor_RunPermanent(port, spd)
            }
            onReleased: {
                forwardButton.border.width = root.height/20
                forwardButton.color = "#474646";
                hubOperator.motor_RunPermanent(port, 0)
            }
        }

        Image {
            id: image
            width: 26
            height: width
            opacity: 0.5
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            fillMode: Image.PreserveAspectFit
            source: "icons/clockwise.svg"

            ColorOverlay{
                source: image
                color: Style.dark_foreground
                anchors.fill: parent
            }
        }
    }

}
