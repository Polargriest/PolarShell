import QtQuick
import qs.globals
import "fetch"

Widget {
    id: widget

    WidgetPill {
        id: leaderPill
        expanded: widget.isOpen

        collapsedView: CollapsedFetch {}
        expandedView: ExpandedFetch {}

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: widget.isOpen = !widget.isOpen
        }
    }
}