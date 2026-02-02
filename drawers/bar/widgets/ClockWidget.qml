import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.globals
import qs.services

// CLOCK WIDGET
//
// reloj. Al tocarlo debe de abrir un calendario

Rectangle {
    id: widget
    clip: true

    property bool isOpen: false // wether if the clock is expanded or not.

    // layour alignments so it can expand correctly
    Layout.alignment: Qt.AlignTop

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

    // ---------- COLLAPSED VIEW ----------
    // pill with time

    Text {
        // we grab the time using the SystemTime servece. its saved in a singleton in services/Time.qml
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
    }

    // ---------- EXPANDED VIEW ----------
    // pill with time, date and an integrated calendar.

    Component {
        id: expanded

        ColumnLayout {
            width: childrenRect.width
            height: childrenRect.height

            Column {
                spacing: 1

                Text {
                    id: expanded_clock
                    text: Configs.bar.clock_widget.use_12hrs ? Qt.formatDateTime(Time.now, "hh:mm:ss AP") : Qt.formatDateTime(Time.now, "hh:mm:ss")
                    color: Theme.colors.blue
                    font.pixelSize: 34
                    font.bold: true
                    font.family: "JetBrains Mono NFP"
                }

                Text {
                    id: expanded_date

                    // we want to format the date as "Saturday, 31st January 2026."
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
                    font.pixelSize: 18
                    font.bold: true
                    font.family: "JetBrains Mono NFP"
                }

                Layout.topMargin: 25
                Layout.leftMargin: 12
                Layout.rightMargin: 50
                Layout.bottomMargin: 25
            }

            visible: opacity > 0
        }
    }

    Loader {
        id: expanded_loader

        // keep this loaded while its open, or while its still closing.
        active: widget.isOpen || widget.Layout.preferredWidth > collapsed.implicitWidth

        sourceComponent: expanded
    }

    // ----- STATES & ANIMATIONS ------
    state: (isOpen && expanded_loader.status === Loader.Ready) ? "opened" : "closed"

    states: [
        State {
            name: "opened"
            // when you close it, there is a single frame where expander_loader unloads the item but the state is still
            // null. in order to avoid warnings, we check if the loader still has the item.
            PropertyChanges { widget.Layout.preferredWidth: expanded_loader.item ? expanded_loader.item.implicitWidth : widget.width}
            PropertyChanges { widget.Layout.preferredHeight: expanded_loader.item ? expanded_loader.item.implicitHeight : widget.height }
            PropertyChanges { collapsed.opacity: 0 }
            PropertyChanges { expanded_loader.opacity: 1 }
        },
        State {
            name: "closed"
            PropertyChanges { widget.Layout.preferredWidth: collapsed.implicitWidth }
            PropertyChanges { widget.Layout.preferredHeight: collapsed.implicitHeight }
            PropertyChanges { collapsed.opacity: 1 }
            PropertyChanges { expanded_loader.opacity: 0 }
        }
    ]

    transitions: [
        Transition {
            from: "*"; to: "*";

            NumberAnimation {
                properties: "widget.Layout.preferredWidth,widget.Layout.preferredHeight,collapsed.opacity,expanded_loader.opacity"
                duration: Configs.bar.widgets_animations
                easing.type: Easing.OutBack
            }
        }
    ]
}