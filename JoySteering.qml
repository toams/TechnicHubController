import QtQuick 2.0
import QtQuick.Controls.Material 2.2

import ".."
import "qrc:/Controls"

Parent{
    id:root
    type: 0
    property int minWidth: Units.dp(140)
    property int maxWidth: Units.dp(200)

    onSizeMinusClicked: {
        if(width > minWidth) {

            width -= Units.dp(20);
            height = width;
        }
    }

    onSizePlusClicked: {
        if(width < maxWidth) {

            width += Units.dp(20);
            height = width;
        }
    }

    CustomCircle{
        id:background
        anchors.fill: parent
        borderWidth: Units.dp(6)
        borderColor: ConstList_Color.controls_border_color
    }
}