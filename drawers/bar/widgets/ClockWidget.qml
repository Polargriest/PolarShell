import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.globals
import qs.services

pragma ComponentBehavior: Bound

// CLOCK WIDGET
//
// reloj. Al tocarlo debe de abrir un calendario

Rectangle {
    id: widget
    property bool isOpen: false // wether if the clock is expanded or not.

    // layour alignments so it can expand correctly
    Layout.alignment: Qt.AlignTop
    Layout.preferredWidth: isOpen ? expanded.width : collapsed.width
    Layout.preferredHeight: isOpen ? expanded.height : collapsed.height

    // appearence
    color: Theme.colorWithAlpha(Theme.colors.bg, 0.6)
    radius: 17
    border.width: 2
    border.color: Theme.colors.bg

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor

        onClicked: {
            widget.isOpen = !widget.isOpen;
        }
    }

    // collapsed view: just show the clock in a pill
    Text {
        // el texto lo agarramos usando el servicio de SystemTime. éste está guardado en un singleton guardado en
        // services/Time.qml
        text: Configs.bar.clock_widget.use_12hrs ? Qt.formatDateTime(Time.now, "hh:mm AP") : Qt.formatDateTime(Time.now, "hh:mm")
        id: collapsed
        
        color: Theme.colors.blue
        font.bold: true
        font.pixelSize: 18
        font.family: "JetBrains Mono NFP"

        anchors.centerIn: parent
        topPadding: 5
        bottomPadding: 5
        rightPadding: 12
        leftPadding: 12

        // TODO: animations
        opacity: widget.isOpen ? 0 /* invisible if opened */ : 1 /* visible if opened*/
        visible: opacity > 0
    }

    ColumnLayout {
        id: expanded

        Column {
            spacing: 1

            Text {
                text: Configs.bar.clock_widget.use_12hrs ? Qt.formatDateTime(Time.now, "hh:mm:ss AP") : Qt.formatDateTime(Time.now, "hh:mm:ss")
                color: Theme.colors.blue
                font.bold: true
                font.pixelSize: 34
                font.family: "JetBrains Mono NFP"
            }

            Text {
                // we want to format the date as "Saturday, 31st January 2026."
                // TODO: this should only execute just when the widget its open.
                text: {
                    function get_ordinal(d: string): string {
                        if (d > 3 && d < 21) return 'th'; // because 11th, 12th & 13th are exceptions
                        switch (d % 10) {
                            case 1: return "st";
                            case 2: return "nd";
                            case 3: return "rd";
                            default: return "th";
                        }
                    }

                    text: {
                        let date = Time.now
                        let dayNum = Qt.formatDateTime(Time.now, "d")

                        return Qt.formatDateTime(date, "dddd, d") + get_ordinal(parseInt(dayNum)) + " " + Qt.formatDateTime(date, "MMMM yyyy")
                    }
                }
                color: Theme.colors.text_color
                font.bold: true
                font.pixelSize: 18
                font.family: "JetBrains Mono NFP"
            }

            Layout.topMargin: 25
            Layout.leftMargin: 12
            Layout.rightMargin: 50
            Layout.bottomMargin: 25
        }

        // TODO: animations
        opacity: widget.isOpen ? 1 /* invisible if opened */ : 0 /* visible if opened*/
        visible: opacity > 0
    }

    // ----- animations ------
    Behavior on Layout.preferredWidth {
        NumberAnimation  {
            duration: Configs.bar.widgets_animations
            easing.type: Easing.OutBack
        }
    }

    Behavior on Layout.preferredHeight {
        NumberAnimation  {
            duration: Configs.bar.widgets_animations
            easing.type: Easing.OutBack
        }
    }
}