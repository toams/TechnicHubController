import QtQuick 2.9
import QtQuick.Window 2.3
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtQuick.Layouts 1.0
import "qrc:/Pages"
import "qrc:/Controls"
import "qrc:/assets"
import "."

ApplicationWindow {
    id: window
    width: Screen.width
    height:Screen.height
    visible: true
    color: Material.background

    Component.onCompleted: {
        darkTheme(cpp_Settings.getDarkMode())
    }

    Connections{
        target:cpp_Settings
        onThemeChanged:{
            window.darkTheme(value);
        }
    }

    function darkTheme(value){

        Material.theme = value ? Material.Dark : Material.Light
        Material.background = value ? ConstList_Color.darkBackground : ConstList_Color.lightBackground
        //Material.accent = "#03a9f4"
        cpp_Android.setStatusBarColor(Material.accent)
        cpp_Android.setNavigationBarColor(Material.background)
        Material.primary = value ? ConstList_Color.darkPrimary : ConstList_Color.lightPrimary
        Material.foreground = value ? ConstList_Color.darkForeground : ConstList_Color.lightForeground
        ConstList_Color.controls_border_color = value ? ConstList_Color.dark_controls_border_color : ConstList_Color.light_controls_border_color
    }

    Material.onAccentChanged: {
        cpp_Android.setStatusBarColor(Material.accent)
    }

    Material.onBackgroundColorChanged: {
        cpp_Android.setNavigationBarColor(Material.background)
    }

    ///////////////////////////////////////////////

    Shortcut{
        sequences:["Backspace","Back"]
        onActivated: stackView.backPushed();
    }

    header: ToolBar {
        id: toolBar
        height: Units.dp(48)
        Material.background: Material.accent
        visible: stackView.currentItem.title !== "*" ? true : false

        RowLayout {
            spacing: Units.dp(10)
            anchors.fill: parent
            anchors.leftMargin: Units.dp(15)
            anchors.rightMargin: Units.dp(15)

            ToolButton {
                id: toolButton
                height: Units.dp(48)
                width: Units.dp(48)
                icon.width: Units.dp(24)
                icon.height: Units.dp(24)
                font.weight: Font.Medium
                font.pixelSize: Qt.application.font.pixelSize
                icon.source: stackView.depth > 1 ? "qrc:/assets/icons/toolbar_back.svg" : "qrc:/assets/icons/toolbar_menu.svg"
                onClicked: {

                    if (stackView.depth > 1) {
                        a_back_click.start()
                        stackView.pop()
                    }
                    else {
                        a_forward_click.start()
                        drawer.open()
                    }
                }

                ParallelAnimation{
                    id:a_back_click
                    SequentialAnimation{
                        PropertyAnimation{
                            target:toolButton
                            property:"rotation"
                            to:-180
                            duration: 200
                        }
                        PropertyAnimation{
                            target:toolButton
                            property:"rotation"
                            to:0
                            duration: 1
                        }
                    }
                }

                ParallelAnimation{
                    id:a_forward_click
                    SequentialAnimation{
                        PropertyAnimation{
                            target:toolButton
                            property:"rotation"
                            to:180
                            duration: 200
                        }
                        PropertyAnimation{
                            target:toolButton
                            property:"rotation"
                            to:0
                            duration: 1
                        }
                    }
                }

            }

            Label {
                text: stackView.currentItem.title
                font.weight: Font.Medium
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                color: Material.foreground
                font.pixelSize: Qt.application.font.pixelSize  * 1.3
            }

            ToolButton{
                id:addButton
                height: Units.dp(48)
                width: Units.dp(48)
                icon.width: Units.dp(24)
                icon.height: Units.dp(24)
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                icon.source: setAddButtonIcon(stackView.currentItem.title)
                visible: addButtonVisibleParse(stackView.currentItem.isAddButtonVisible)
                onClicked:{
                    switch(stackView.currentItem.title){
                        case ConstList_Text.page_connectedDevices: stackView.push(component_Finder); break;
                            case ConstList_Text.page_profiles: cpp_Profiles.addProfile(ConstList_Text.profile_new_name); break;
                        default : break;
                    }
                }

                function addButtonVisibleParse(value){
                    if(value !== undefined) return value;
                    else return false;
                }
                function setAddButtonIcon(title){
                    switch(title){
                        case ConstList_Text.page_connectedDevices: return "qrc:/assets/icons/connectedDevice.svg";
                            case ConstList_Text.page_profiles: return "qrc:/assets/icons/add.svg";
                                default : return "";
                    }
                }
            }
        }
    }

    CustomDrawer {
        id: drawer
        width: window.width * 0.66
        height: window.height
        dragMargin:Units.dp(Qt.styleHints.startDragDistance)
        Material.elevation: Units.dp(8)

        Behavior on position {
            NumberAnimation{ duration: 200 }
        }

        function collapse(){
            position = 0;
            visible = false;
        }

        SidePanel{
            anchors.fill: parent
            onClicked: {
                switch(page){               
                case "connectedDevices":stackView.replace(component_ConnectedDevices);break;
                    case "profiles":stackView.replace(component_Profiles);break;
                        case "settings":stackView.push(component_Settings);break;
                            case "about":stackView.push(component_About);break;

                }
                drawer.collapse();
            }
        }
    }

    StackView {
        id: stackView
        initialItem: component_ConnectedDevices
        anchors.fill: parent
        onCurrentItemChanged: {
            if(currentItem.title === ConstList_Text.sidepanel_item1) window.Material.accent = ConstList_Color.accentGreen
                if(currentItem.title === ConstList_Text.sidepanel_item2) window.Material.accent = ConstList_Color.accentBlue
                    if(currentItem.title === ConstList_Text.sidepanel_item3) window.Material.accent = ConstList_Color.accentRed
                        if(currentItem.title === ConstList_Text.sidepanel_item4) window.Material.accent = ConstList_Color.accentYellow
                            if(currentItem.title === "*") window.Material.accent = ConstList_Color.accentGreen
        }

        function backPushed(){
            if (stackView.depth > 1) {
                a_back_click.start()
                stackView.pop()
            }
            else{
                console.log("TRY CLOSE")
                Qt.quit(0);
            }
        }
    }

    Component{id:component_Profiles;Profiles{}}

    ConnectedDevices{id:component_ConnectedDevices}

    Component{id:component_Finder; Finder{}}

    Component{id:component_Connector;Connector{}}

    Component{id:component_Settings;Settings{}}

    Component{id:component_About;About{}}

    Component{id:component_ProfilePlayer;ProfilePlayer{}}
}
