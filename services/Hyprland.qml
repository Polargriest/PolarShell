import QtQuick
import Quickshell
import Quickshell.Hyprland

pragma Singleton

Singleton {
    readonly property var toplevels: Hyprland.toplevels
    
    readonly property var workspaces: Hyprland.workspaces

    // this tell us what application is currently active.
    readonly property HyprlandToplevel activeToplevel: Hyprland.activeToplevel?.wayland?.activated ? Hyprland.activeToplevel : null
    readonly property var activeToplevelClass: activeToplevel?.wayland?.appId
    readonly property var activeToplevelTitle: activeToplevel?.wayland?.title

    function isSelected(workspace: HyprlandWorkspace): bool {
        return HyprlandWorkspace
    }
}