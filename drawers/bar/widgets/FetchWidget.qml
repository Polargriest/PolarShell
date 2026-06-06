import QtQuick
import "fetch"

Widget {
    id: widget

    WidgetPill {
        id: leaderPill
        expanded: widget.isOpen

        marginHorizontal: 0
        marginVertical: 0

        collapsedView: CollapsedFetch {}
        expandedView: ExpandedFetch {}

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: widget.isOpen = !widget.isOpen
        }
    }

    SystemHealthPill {
        leaderPill: leaderPill
        expanded: widget.isOpen
    }

    MoreOptionsPill {
        widget: widget
        leaderPill: leaderPill
        expanded: widget.isOpen
    }
}