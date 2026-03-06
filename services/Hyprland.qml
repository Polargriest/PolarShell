import QtQuick
import Quickshell
import Quickshell.Hyprland

pragma Singleton

Singleton {
    readonly property var workspaces: Hyprland.workspaces

    function isSelected(workspace: HyprlandWorkspace): bool {
        return HyprlandWorkspace
    }
}