import QtQuick
import QtQuick.Layouts
import qs.globals
import "widgets" as Widgets

// BAR.QML

// the upper bar. This item contains layouts for left and right widgets. Also, displays the window title in a
// notch style.

Item {
    width: parent.width // takes all horizontal space
    height: Configs.bar.height + Configs.screen.gapsOut // bar height + indicated Hyprland margins between windows

    // HACK: really bad, but I don't know how to do it i'm so sorry and this is the only idea i had :sob:
    // this list is accessed by Drawers.qml to create clickable regions for opened widgets.
    property var openedPanels: [fetch, clock, audio, workspaces, title]
    property var anyPanelOpened: openedPanels.some(panel => panel.isOpen)

    // Rectangle {
    //     anchors.fill: parent
    //     color: "transparent"
    //     border.color: "red"
    //     border.width: 2
    // }

    RowLayout {
        id: widgets

        width: parent.width
        height: Configs.bar.height
        anchors.bottom: parent.bottom // sits at the bottom of the container
        spacing: 0

        property real freeSpace: width - leftWidgets.width - rightWidgets.width - Configs.screen.gapsOut

        // TODO: only one widget should be able to be open at a time.

        // left widgets
        RowLayout {
            id: leftWidgets

            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
            Layout.leftMargin: Configs.screen.gapsOut / (Configs.bar.title.style === "Notch" ? 2 : 1)
            Layout.topMargin: (Configs.bar.title.style === "Notch" ? Configs.bar.title.distanceFromTop / 2 : 0)
            spacing: 10

            // ----- WIDGETS -----
            Widgets.FetchWidget { id: fetch }
            Widgets.Workspaces { id: workspaces }
            
        }

        // right widgets
        RowLayout {
            id: rightWidgets

            Layout.alignment: Qt.AlignRight | Qt.AlignTop
            Layout.topMargin: (Configs.bar.title.style === "Notch" ? Configs.bar.title.distanceFromTop / 2 : 0)
            Layout.rightMargin: Configs.screen.gapsOut / (Configs.bar.title.style === "Notch" ? 2 : 1)
            layoutDirection: Qt.RightToLeft
            spacing: 10

            // ----- WIDGETS -----
            Widgets.ClockWidget { id: clock }
            Widgets.AudioWidget { id: audio }
        }
    }

    Widgets.Title {
        id: title;

        freeSpace: widgets.freeSpace
        leftWidgetsSpace: leftWidgets.width
        rightWidgetsSpace: rightWidgets.width
    }
}