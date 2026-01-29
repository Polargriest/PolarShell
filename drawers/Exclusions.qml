import Quickshell
import QtQuick

Scope {
    id: root
    required property ShellScreen screen

    PanelWindow {
        anchors {
            top: true
            left: true
            right: true
        }

        screen: root.screen
        exclusiveZone: 100
        mask: Region {}
        color: "transparent"
        implicitHeight: 1
        implicitWidth: 1
    }
}