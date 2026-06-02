import Quickshell

Region {
    required property var bar
    required property var win

    width: bar.anyPanelOpened ? win.width : bar.width
    height: bar.anyPanelOpened ? win.height : bar.height
}