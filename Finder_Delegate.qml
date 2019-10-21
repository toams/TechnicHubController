import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtGraphicalEffects 1.0
import "qrc:/assets"
import ".."

Item {
    id:root
    implicitHeight: Units.dp(40)
    height: Units.dp(40)
    width: parent.width

    Pane{
        id:background
        anchors.fill: parent
        Material.background: Material.primary
        Material.elevation:Units.dp(4)
    }

    Image {
        id: image
        width: Units.dp(20)
        height: Units.dp(20)
        anchors.left: parent.left
        anchors.leftMargin: Units.dp(10)
        anchors.verticalCenter: parent.verticalCenter
        source: "qrc:/assets/icons/foundedDevice.svg"
        fillMode: Image.PreserveAspectFit
        visible: false
    }

    ColorOverlay{
        source:image
        color:label.color
        smooth: true
        anchors.fill: image
    }

    Label {
        id: label
        text: name
        font.weight: Font.Medium
        font.pixelSize: Qt.application.font.pixelSize;
        anchors.left: image.right
        anchors.leftMargin: Units.dp(10)
        anchors.verticalCenter: parent.verticalCenter
    }

}