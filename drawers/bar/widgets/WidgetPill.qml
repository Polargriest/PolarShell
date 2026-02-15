import QtQuick
import QtQuick.Layouts
import qs.globals

// WidgetPill.qml
// This is a special instance of Pills, where when closed, they don't disappear, but just become smaller.
// Basically, they are always on display.

Rectangle {
    id: root

    required property Component collapsedView
    required property Component expandedView
    property alias expandedItem: expandedLoader.item
    property bool expanded: false

    // layour alignments so it can expand correctly
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

    Layout.preferredWidth: expanded ? expandedLoader.implicitWidth : (collapsedLoader.implicitWidth + 24)
    Layout.preferredHeight: expanded ? expandedLoader.implicitHeight : (collapsedLoader.implicitHeight + 10)

    Loader {
        id: collapsedLoader
        active: !root.expanded || opacity > 0
        sourceComponent: root.collapsedView
        anchors.centerIn: parent

        opacity: root.expanded ? 0 : 1

        Behavior on opacity {
            NumberAnimation {
                duration: Configs.bar.widgetsAnimations / 3
            }
        }
    }

    Loader {
        id: expandedLoader
        active: root.expanded || opacity > 0
        sourceComponent: root.expandedView

        opacity: root.expanded ? 1 : 0

        Behavior on opacity {
            NumberAnimation {
                duration: Configs.bar.widgetsAnimations / 3
            }
        }
    }
}