import QtQuick
import QtQuick.Layouts
import qs.globals
import qs.services
import QtQuick.Controls

// CLOCK WIDGET
// when collapsed, it displays the time. When expanded, it also displays the date.

ColumnLayout {
    id: widget
    spacing: 10
    Layout.alignment: Qt.AlignTop

    property bool isOpen: false // whether if the clock is expanded or not.

    // ---------- PILL #1 : Time and date ----------
    Rectangle {
        id: timeAndDate

        // layour alignments so it can expand correctly
        Layout.alignment: Qt.AlignTop
        Layout.preferredWidth: !widget.isOpen ? collapsed1.width : expandedLoader.width
        Layout.preferredHeight: collapsed1.height

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
                // TODO: should also be closed with ESC
                widget.isOpen = !widget.isOpen;
            }
        }

        // ---------- COLLAPSED VIEW ----------
        Text {
            id: collapsed1
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
            id: expandedComponent1

            ColumnLayout {
                Layout.preferredWidth: expanded1.width
                Layout.preferredHeight: expanded1.height
                Layout.alignment: Qt.AlignTop

                Column {
                    id: expanded1
                    spacing: 1

                    Text {
                        text: Time.getFormattedTime(true)

                        // style
                        color: Theme.colors.blue
                        font.pixelSize: 34
                        font.bold: true
                        font.family: "JetBrains Mono NFP"
                    }

                    Text {
                        text: Time.getFormattedDate()

                        // style
                        color: Theme.colors.secondaryText
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
            active: widget.isOpen || opacity > 0
            opacity: widget.isOpen ? 1 : 0
            sourceComponent: expandedComponent1

            Behavior on opacity {
                NumberAnimation { duration: Configs.bar.widgetsAnimations }
            }
        }
    }

    // ---------- PILL #2 : Calendar ----------
    // TODO: this shouldn't be loaded always. Wrap it inside a loader.
    Rectangle {
        id: calendar

        Layout.alignment: Qt.AlignRight

        // appearence
        color: Theme.colorWithAlpha(Theme.colors.bg, 0.6)
        radius: 17
        border.width: 2
        border.color: Theme.colors.bg
        clip: true // masks the overflowing components.

        property int selectedDay: -1

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 15

            // TODO: navigation between months using 1) buttons, 2) scroll bar

            Text {
                text: Qt.locale("en_US").monthName(grid.month, Locale.LongFormat) + " " + grid.year
                color: Theme.colors.orange
                font.bold: true
                font.pixelSize: 28
                font.family: "JetBrains Mono NFP"
                Layout.bottomMargin: 10
            }

            DayOfWeekRow {
                Layout.fillWidth: true
                locale: grid.locale

                delegate: Text {
                    required property var model

                    text: model.shortName
                    color: Theme.colors.secondaryText
                    font.family: "JetBrains Mono NFP"
                    font.bold: true
                    font.pixelSize: 16

                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 2
                radius: 10
                color: Theme.colors.orange
            }

            MonthGrid {
                id: grid
                month: Calendar.February
                year: 2026
                locale: Qt.locale("en_US")

                Layout.fillWidth: true
                Layout.fillHeight: true

                delegate: Rectangle {
                    required property var model

                    color: model.today ? Theme.colors.orange : (dayHitbox.containsMouse ? Theme.colorWithAlpha(Theme.colors.primaryText, "0.2") : "#00000000")
                    border.width: (calendar.selectedDay === model.day && grid.month === model.month) ? 1 : 0
                    border.color: (calendar.selectedDay === model.day && grid.month === model.month) ? Theme.colors.orange : "#00000000"
                    radius: 100

                    Text {
                        text: model.day
                        color: model.today ? Theme.colors.bg : Theme.colors.primaryText
                        opacity: model.month == grid.month ? 1 : 0.5
                        font.family: "JetBrains Mono NFP"
                        font.pixelSize: 16
                        font.bold: model.today

                        anchors.centerIn: parent
                    }

                    MouseArea {
                        id: dayHitbox
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true

                        onClicked:{
                            calendar.selectedDay = model.day

                            grid.year = model.year
                            grid.month = model.month
                        }
                    }

                    Behavior on color {
                        ColorAnimation {
                            duration: 70
                        }
                    }
                }
            }
        }
    }

    // ---------- STATES & ANIMATIONS ----------
    states: [
        State {
            name: "opened"
            when: widget.isOpen && expandedLoader.status == Loader.Ready

            PropertyChanges {
                timeAndDate.Layout.preferredWidth: expandedLoader.implicitWidth
                timeAndDate.Layout.preferredHeight: expandedLoader.implicitHeight
                collapsed1.opacity: 0

                calendar.opacity: 1
                calendar.Layout.preferredWidth: expandedLoader.implicitWidth
                calendar.Layout.preferredHeight: 385
            }
        },

        State {
            name: "closed"
            when: !widget.isOpen

            PropertyChanges {
                timeAndDate.Layout.preferredWidth: collapsed1.implicitWidth
                timeAndDate.Layout.preferredHeight: collapsed1.implicitHeight
                collapsed1.opacity: 1

                calendar.opacity: 0
                calendar.Layout.preferredWidth: 0
                calendar.Layout.preferredHeight: 0
            }
        }
    ]

    transitions: [
        Transition {
            NumberAnimation {
                properties: "timeAndDate.Layout.preferredWidth,timeAndDate.Layout.preferredHeight,collapsed1.opacity,expandedLoader1.opacity,calendar.Layout.preferredWidth,calendar.Layout.preferredHeight,calendar.opacity"
                duration: Configs.bar.widgetsAnimations
                easing.type: Easing.OutBack
            }
        }
    ]
}