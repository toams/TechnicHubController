import QtQuick 2.11
import QtQuick.Window 2.11
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import "."

ApplicationWindow {
    id: window
    visible: true
    color: Material.background

    Component.onCompleted:{
        setDarkTheme(true);
        androidFunc.setOrientation("portraite");
    }

    function setDarkTheme(param){
        return param? setDark():setLight();
    }
    function setDark(){

        Material.theme = Material.Dark
        Material.background = Style.dark_background;
        Material.primary = Style.dark_primary;
        Material.accent = Style.dark_accent;
        Material.foreground = Style.dark_foreground
    }
    function setLight(){
        Material.theme = Material.Light
        Material.background = Style.light_background;
        Material.primary = Style.light_primary;
        Material.accent = Style.light_accent;
        Material.foreground = Style.light_foreground
    }

    Shortcut {
        sequence: "Back"
        //sequence: "Backspace"
        onActivated:{
            stackView.pop();
            if(swipe.currentIndex == 0){
                console.log("quit");
                Qt.quit();
            }
        }
    }

    ListModel{
        id:controlModel
        ListElement{
            name: "Рулевое управление";
            ico: "icons/steering.svg"
            element:"Profile_Control_Steering.qml"
        }
        ListElement{
            name: "Управление передвижением";
            ico: "icons/moving.svg"
            element:"Profile_Control_Moving.qml"
        }
        ListElement{
            name: "Линейная кнопка";
            ico: "icons/linear.svg"
            element:"Profile_Control_HoldButtons.qml"
        }
    }

    SwipeView{
        id:swipe
        anchors.fill: parent
        clip: true
        visible: true
        interactive: false
        currentIndex: 1

        Page_Finder{
            id:finder
            clip: true
            onDeviceWasConnected: {
                swipe.incrementCurrentIndex();
            }

        }

        StackView{
            id:stackView
            clip: true
            initialItem: usrProfiles
        }
    }

    Component{
        id:usrProfiles
        Page_UsersProfile{
        }
    }

    Component{
        id:profile
        Page_Profile{
        }
    }
}
