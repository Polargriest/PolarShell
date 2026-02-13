import QtQuick
import QtQuick.Layouts
import qs.globals
import qs.services
import QtQuick.Controls
import "clock"

// CLOCK WIDGET
// when collapsed, it displays the time. When expanded, it also displays the date.

Widget {
    id: widget

    WidgetPill {
        id: leaderPill
        expanded: widget.isOpen

        collapsedView: CollapsedClock {}
        expandedView: ExpandedClock {}

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: widget.isOpen = !widget.isOpen
        }
    }

    WorldClockPill {
        expanded: widget.isOpen
        widget: widget
        leaderPill: leaderPill
        visible: Configs.bar.clock.worldClockCities.length > 0
    }

    CalendarPill {
        expanded: widget.isOpen
        widget: widget
        leaderPill: leaderPill
    }
}