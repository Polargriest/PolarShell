import QtQuick
import QtQuick.Layouts
import qs.globals
import qs.services

// CLOCK WIDGET
// when collapsed, it displays the time. When expanded, it also displays the date.
// TODO: it must show a calendar as well.

Rectangle {
    id: widget

    property bool isOpen: false // whether if the clock is expanded or not.

    // layour alignments so it can expand correctly
    Layout.alignment: Qt.AlignTop

    // appearence
    color: Theme.colorWithAlpha(Theme.colors.bg, 0.6)
    radius: 17
    border.width: 2
    border.color: Theme.colors.bg
    clip: true // masks the overflowing components.

    // ---------- CLICK LOGIC ----------
    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor

        onClicked: {
            widget.isOpen = !widget.isOpen;
        }
    }

    // ---------- COLLAPSED VIEW ----------
    Text {
        id: collapsed
        visible: opacity > 0

        // we grab the time using the SystemTime servece. its saved in a singleton in services/Time.qml
        text: Time.getFormattedTime(false)
        
        // styling
        color: Theme.colors.blue
        font.bold: true
        font.pixelSize: 18
        font.family: "JetBrains Mono NFP"

        // layout and margins
        anchors.centerIn: parent
        topPadding: 5
        bottomPadding: 5
        rightPadding: 12
        leftPadding: 12
    }

    // ---------- EXPANDED VIEW ----------
    Component {
        id: expanded

        ColumnLayout {

            Column {
                spacing: 1

                Text {
                    id: expanded_clock
                    text: Time.getFormattedTime(true)

                    // style
                    color: Theme.colors.blue
                    font.pixelSize: 34
                    font.bold: true
                    font.family: "JetBrains Mono NFP"
                }

                Text {
                    id: expanded_date
                    text: Time.getFormattedDate()

                    // style
                    color: Theme.colors.text_color
                    font.pixelSize: 18
                    font.bold: true
                    font.family: "JetBrains Mono NFP"
                }

                // we leave some margins so the pill looks less cluttered.
                Layout.topMargin: 25
                Layout.leftMargin: 12
                Layout.rightMargin: 50
                Layout.bottomMargin: 25
            }
        }
    }

    Loader {
        id: expandedLoader

        // keep this loaded while its open, or while its still closing.
        active: widget.isOpen || widget.Layout.preferredWidth > collapsed.implicitWidth

        sourceComponent: expanded
    }

    // ---------- STATES & ANIMATIONS ----------
    states: [
        State {
            name: "opened"
            when: widget.isOpen && expandedLoader.status == Loader.Ready

            PropertyChanges {
                widget.Layout.preferredWidth: expandedLoader.item.implicitWidth
                widget.Layout.preferredHeight: expandedLoader.item.implicitHeight
                collapsed.opacity: 0
                expandedLoader.opacity: 1
            }
        },

        State {
            name: "closed"
            when: !widget.isOpen

            PropertyChanges {
                widget.Layout.preferredWidth: collapsed.implicitWidth
                widget.Layout.preferredHeight: collapsed.implicitHeight
                collapsed.opacity: 1
                expandedLoader.opacity: 0
            }
        }
    ]

    transitions: [
        Transition {
            from: "*"; to: "*";

            NumberAnimation {
                properties: "widget.Layout.preferredWidth,widget.Layout.preferredHeight,collapsed.opacity,expandedLoader.opacity"
                duration: Configs.bar.widgetsAnimations
                easing.type: Easing.OutBack
            }
        }
    ]
}