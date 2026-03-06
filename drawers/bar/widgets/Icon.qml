import QtQuick
import qs.globals

// CLOCK WIDGET
// when collapsed, it displays the time. When expanded, it also displays the date.

Widget {
    id: widget

    WidgetPill {
        id: leaderPill

        expandedView: Item {}
        collapsedView: Text {
            text: ""

            height: 24
            
            // styling
            color: Theme.colors.green
            font.bold: true
            font.pixelSize: 16
            font.family: "JetBrainsMono NFP Custom"

            // layout and margins
        }
    }
}