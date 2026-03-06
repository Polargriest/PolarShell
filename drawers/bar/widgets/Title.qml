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
            text: "Zen Browser"
            
            // styling
            color: Theme.colors.primaryText
            font.bold: true
            font.pixelSize: 18
            font.family: "JetBrains Mono NFP"

            // layout and margins
        }
    }
}