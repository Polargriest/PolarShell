import QtQuick
import Quickshell
import QtQuick.Layouts
import qs.globals
import "widgets" as Widgets

// BAR.QML

// the upper bar. This item contains layouts for left and right widgets. Also, displays the window title in a
// notch style.

Item {
    width: parent.width // takes all horizontal space
    height: Configs.bar.height + Configs.screen.gapsOut // bar height + indicated Hyprland margins between windows

    // Rectangle {
    //     anchors.fill: parent
    //     color: "transparent"
    //     border.width: 2
    //     border.color: "red"
    // }

    // HACK: really bad, but I don't know how to do it i'm so sorry and this is the only idea i had :sob:
    // this list is accessed by Drawers.qml to create clickable regions for opened widgets.
    property var openedPanels: [fetch, clock, audio, workspaces, title]

    RowLayout {
        width: parent.width
        height: Configs.bar.height
        anchors.bottom: parent.bottom // sits at the bottom of the container
        spacing: 0

        // TODO: only one widget should be able to be open at a time.

        // left widgets
        RowLayout {
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
            Layout.leftMargin: Configs.screen.gapsOut
            Layout.topMargin: 5
            spacing: 10

            // ----- WIDGETS -----
            Widgets.FetchWidget { id: fetch }
            Widgets.Workspaces { id: workspaces }
            
        }

        // right widgets
        RowLayout {
            id: rightWidgets

            Layout.alignment: Qt.AlignRight | Qt.AlignTop
            Layout.topMargin: 5
            Layout.rightMargin: Configs.screen.gapsOut
            layoutDirection: Qt.RightToLeft
            spacing: 10

            // ----- WIDGETS -----
            Widgets.ClockWidget { id: clock }
            Widgets.AudioWidget { id: audio }
        }
    }

    Widgets.Title { id: title; anchors.horizontalCenter: parent.horizontalCenter }
}