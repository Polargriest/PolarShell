import QtQuick
import QtQuick.Layouts
import qs.globals

// Pill.qml
// This represents a pill of information inside a widget. It disappears when closed.

Rectangle {
    id: root

    required property var widget
    required property WidgetPill leaderPill
    required property Component contentComponent
    property bool expanded: false

    Layout.preferredWidth: expanded && leaderPill.expandedItem ? leaderPill.expandedItem.implicitWidth : -1
    Layout.preferredHeight: expanded ? implicitHeight : -1

    // layour alignments so it can expand correctly with animations.
    Layout.alignment: Qt.AlignTop
    Behavior on Layout.preferredHeight {
        NumberAnimation {
            duration: Configs.bar.widgetsAnimations
            easing.type: Easing.OutBack
        }
    }
    Behavior on Layout.preferredWidth {
        NumberAnimation {
            duration: Configs.bar.widgetsAnimations
            easing.type: Easing.OutBack
        }
    }

    // appearence
    color: Theme.colorWithAlpha(Theme.colors.bg, 0.6)
    radius: 17
    border.width: 2
    border.color: Theme.colors.bg
    clip: true // masks the overflowing components.

    Loader {
        id: expandedLoader
        anchors.fill: parent

        active: root.expanded || opacity > 0
        sourceComponent: root.contentComponent
        opacity: root.expanded ? 1 : 0

        Behavior on opacity {
            NumberAnimation {
                duration: Configs.bar.widgetsAnimations / 5
            }
        }
    }
}