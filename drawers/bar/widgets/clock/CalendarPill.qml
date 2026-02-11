import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import ".."
import qs.globals


Pill {
    id: calendar

    readonly property int monthPageHeight: 360

    Layout.alignment: Qt.AlignRight
    implicitHeight: 418

    property date selectedDate: new Date()
    property date visibleMonth: new Date()

    contentComponent: ColumnLayout {
        anchors.fill: parent
        anchors.margins: 15

        RowLayout { // NAVIGATION PART OF THE CALENDAR. Displays month and arrows.
            Layout.bottomMargin: 10
            spacing: 20

            Rectangle { // down arrow (next month)
                width: 40
                height: 40
                radius: 100

                color: upHitbox.containsMouse ? Theme.colorWithAlpha(Theme.colors.primaryText, "0.1") : "#00000000"

                Behavior on color {
                    ColorAnimation { duration: 100}
                }

                Image {
                    anchors.centerIn: parent
                    source: "file:assets/icons/up_arrow"
                    sourceSize.width: 20
                }

                MouseArea {
                    id: upHitbox
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true

                    onClicked: monthFlicker.flick(0, 2000)
                }
            }

            Rectangle {
                color: monthFlicker.monthOffset == -1 ? "#00000000" : (monthNameHitbox.containsMouse ? Theme.colorWithAlpha(Theme.colors.primaryText, "0.1") : "#00000000")
                Layout.fillWidth: true
                implicitHeight: 40
                radius: 100

                Behavior on color {
                    ColorAnimation { duration: 100}
                }

                Text { // selected month indicator
                id: textMonth
                    text: {
                        const lm =
                            calendar.visibleMonth.getFullYear() * 12 +
                            calendar.visibleMonth.getMonth() +
                            monthFlicker.monthOffset + 1

                        const year = Math.floor(lm / 12)
                        const month = ((lm % 12) + 12) % 12

                        return Qt.locale(Configs.bar.clock.calendarLocalization).monthName(month, Locale.LongFormat)
                            + " " + year
                    }
                    color: Theme.colors.orange
                    font.bold: true
                    font.pixelSize: 24
                    font.family: "JetBrains Mono NFP"
                    anchors.fill: parent
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }

                MouseArea {
                    id: monthNameHitbox
                    anchors.fill: parent
                    cursorShape: monthFlicker.monthOffset == -1 ? Qt.ArrowCursor : Qt.PointingHandCursor
                    hoverEnabled: true

                    onClicked: monthFlicker.monthOffset = -1
                }
            }

            Rectangle { // down arrow (next month)
                width: 40
                height: 40
                radius: 100

                color: downHitbox.containsMouse ? Theme.colorWithAlpha(Theme.colors.primaryText, "0.1") : "#00000000"

                Behavior on color {
                    ColorAnimation { duration: 100}
                }

                Image {
                    anchors.centerIn: parent
                    source: "file:assets/icons/down_arrow"
                    sourceSize.width: 20
                }

                MouseArea {
                    id: downHitbox
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true

                    onClicked: monthFlicker.flick(0, -2000)
                }
            }
        }

        DayOfWeekRow { // DAY OF WEEK INDICATOR (Sun, Mon, Tue...)
            Layout.fillWidth: true
            locale: Qt.locale(Configs.bar.clock.calendarLocalization)

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

        Rectangle { // divider line
            Layout.fillWidth: true
            Layout.preferredHeight: 2
            radius: 10
            color: Theme.colors.orange
        }

        Item {
            id: monthWrapper
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            readonly property int pageCount: 3
            readonly property real pageHeight: height

            Flickable {
                id: monthFlicker

                implicitWidth: parent.width
                implicitHeight: parent.height
                clip: true
                boundsBehavior: Flickable.StopAtBounds

                contentWidth: width
                contentHeight: monthWrapper.pageHeight * monthWrapper.pageCount // height = 3 months

                property int monthOffset: -1 // -1 so the middle can be 0
                property bool isSnapping: false // flag because upward scrolling was glitched

                onHeightChanged: {
                    if (widget.isOpen) {
                        monthOffset = -1
                        contentY = height
                    }
                }

                onContentYChanged: {
                    if (isSnapping) return

                    if (contentY >= (height*2 - 1)) {
                        monthOffset++
                        contentY = height
                    }

                    if (contentY <= 1) {
                        monthOffset--
                        contentY = height
                    }
                }

                onMovementEnded: {
                    if (contentY >= (height*2 - 1)) return
                    if (contentY <= 1) return

                    const page = Math.round(contentY / monthWrapper.pageHeight)
                    const desiredContentY = page * monthWrapper.pageHeight

                    isSnapping = true
                    snapAnim.from = contentY
                    snapAnim.to = desiredContentY - 1
                    snapAnim.start()
                }

                NumberAnimation {
                    id: snapAnim
                    target: monthFlicker
                    property: "contentY"
                    duration: 200
                    easing.type: Easing.OutCubic

                    onStopped: {
                        monthFlicker.isSnapping = false

                        const page = Math.round(monthFlicker.contentY / monthWrapper.pageHeight)
                        monthFlicker.contentY = page * monthWrapper.pageHeight

                        if (monthFlicker.contentY >= (monthFlicker.height*2 - 1)) {
                            monthFlicker.monthOffset++
                            monthFlicker.contentY = monthFlicker.height
                        }

                        if (monthFlicker.contentY <= 1) {
                            monthFlicker.monthOffset--
                            monthFlicker.contentY = monthFlicker.height
                        }
                    }
                }

                Item {
                    width: parent.width
                    height: parent.height

                    Repeater {
                        model: 3

                        MonthGrid {                                
                            id: grid
                            locale: Qt.locale(Configs.bar.clock.calendarLocalization)

                            property int linearMonth: (
                                calendar.visibleMonth.getFullYear() * 12 +
                                calendar.visibleMonth.getMonth() +
                                monthFlicker.monthOffset +
                                modelData
                            )

                            year: Math.floor(linearMonth / 12)
                            month: ((linearMonth % 12) + 12) % 12

                            width: parent.width
                            height: parent.height / monthWrapper.pageCount
                            y: parent.height * modelData / monthWrapper.pageCount

                            delegate: Rectangle {
                                required property var model

                                property bool isSelected: (
                                    calendar.selectedDate.getFullYear() === model.year &&
                                    calendar.selectedDate.getMonth() === model.month &&
                                    calendar.selectedDate.getDate() === model.day
                                )

                                color: model.today ? Theme.colors.orange : (dayHitbox.containsMouse ? Theme.colorWithAlpha(Theme.colors.primaryText, 0.1) : "#00000000")
                                border.width: isSelected ? 1 : 0
                                border.color: isSelected ? Theme.colors.orange : "#00000000"
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

                                    onClicked: {
                                        if (calendar.selectedDate.getTime() === model.date.getTime()) {
                                            calendar.selectedDate = new Date()
                                        } else {
                                            calendar.selectedDate = model.date
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}