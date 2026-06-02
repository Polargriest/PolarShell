import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import qs.globals

// CLOCK WIDGET
// when collapsed, it displays the time. When expanded, it also displays the date.

Widget {
    id: widget

    WidgetPill {
        Behavior on Layout.preferredHeight {}
        Behavior on Layout.preferredWidth {}

        id: leaderPill

        marginHorizontal: 2
        Layout.preferredHeight: 34

        expandedView: Item {}
        collapsedView: RowLayout {
            spacing: -3
            implicitWidth: 500
            

            Repeater {
                model: Hyprland.workspaces

                Rectangle {
                    id: workspace
                    required property HyprlandWorkspace modelData

                    Layout.preferredHeight: 30
                    Layout.preferredWidth: modelData.focused ? 60 : 30
                    color: modelData.focused ? Theme.colors.orange : (workspaceHitbox.containsMouse ? Theme.colorWithAlpha(Theme.colors.primaryText, 0.2) : Theme.colorWithAlpha(Theme.colors.bg, 0))
                    radius: 100

                    Behavior on Layout.preferredWidth { NumberAnimation { duration: 250; easing.type: Easing.InOutCubic } }
                    Behavior on color { ColorAnimation { duration: 250 } }

                    Text {
                        text: workspace.modelData.id == -98 ? "" : workspace.modelData.id
                        
                        // styling
                        color: workspace.modelData.focused ? Theme.colors.bg : Theme.colors.primaryText
                        Behavior on color { ColorAnimation { duration: 250 } }
                        font.bold: true
                        font.pixelSize: 18
                        font.family: "JetBrains Mono NFP"

                        // layout and margins
                        anchors.centerIn: parent
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    MouseArea {
                        id: workspaceHitbox
                        anchors.fill: parent
                        cursorShape: !workspace.modelData.focused ? Qt.PointingHandCursor : Qt.ArrowCursor
                        hoverEnabled: true
                        onClicked: {workspace.modelData.activate()}
                    }
                }
            }
        }
    }
}