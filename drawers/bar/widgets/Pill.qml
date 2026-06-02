import QtQuick
import QtQuick.Layouts
import qs.globals

// Pill.qml
// This represents a pill of information inside a widget. It disappears when closed.

Rectangle {
    id: root

    required property WidgetPill leaderPill
    property real componentHeight: 0
    required property Component contentComponent
    property bool expanded: false

    Layout.alignment: parent && parent.parent && parent.parent.alignment !== undefined ? parent.parent.alignment : Qt.AlignLeft

    implicitWidth: expanded && leaderPill.expandedItem ? leaderPill.expandedItem.implicitWidth : 0
    implicitHeight: expanded ? contentLoader.item.implicitHeight + Configs.bar.pillMargins*2 : 0

    Behavior on implicitWidth {
        NumberAnimation {
            duration: Configs.bar.widgetsAnimations
            easing.type: Easing.OutBack
        }
    }
    Behavior on implicitHeight {
        NumberAnimation {
            duration: Configs.bar.widgetsAnimations
            easing.type: Easing.OutBack
        }
    }

    // appearence
    color: Theme.colorWithAlpha(Theme.colors.bg, Theme.colors.transparency)
    radius: 17
    border.width: 2
    border.color: Theme.colors.bg
    clip: true // masks the overflowing components.

    Loader {
        id: contentLoader

        anchors.fill: parent
        anchors.margins: 15

        active: root.expanded || opacity > 0
        sourceComponent: root.contentComponent
        opacity: root.expanded ? 1 : 0

        Behavior on opacity {
            NumberAnimation {
                duration: Configs.bar.widgetsAnimations / 3
            }
        }
    }
}