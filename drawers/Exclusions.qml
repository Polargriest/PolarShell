import Quickshell
import QtQuick
import qs.globals

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
        exclusiveZone: Configs.bar.height
        mask: Region {}
        color: "transparent"
    }
}