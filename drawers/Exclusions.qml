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
        exclusiveZone: Configs.bar.height + Configs.screen.gaps_out
        mask: Region {}
        color: "transparent"
    }

    PanelWindow {
        anchors {
            left: true
        }

        screen: root.screen
        exclusiveZone: Configs.screen.gaps_out
        mask: Region {}
        color: "transparent"
    }

    PanelWindow {
        anchors {
            right: true
        }

        screen: root.screen
        exclusiveZone: Configs.screen.gaps_out
        mask: Region {}
        color: "transparent"
    }

    PanelWindow {
        anchors {
            bottom: true
        }

        screen: root.screen
        exclusiveZone: Configs.screen.gaps_out
        mask: Region {}
        color: "transparent"
    }
}