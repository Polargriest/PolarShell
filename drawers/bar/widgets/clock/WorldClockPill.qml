import QtQuick
import QtQuick.Layouts
import qs.globals
import qs.services
import ".."

Pill {
    contentComponent: ColumnLayout {
        id: component

        Layout.alignment: Qt.AlignTop
        Layout.fillWidth: true

        Text {
            text: "World Clock"
            color: Theme.colors.purple
            font.bold: true
            font.pixelSize: 24
            font.family: "JetBrains Mono NFP"
        }

        Rectangle {
            Layout.preferredHeight: 1
            Layout.fillWidth: true
            color: Theme.colors.purple
        } // spacing

        Repeater {
            model: Configs.bar.clock.worldClockCities

            delegate: RowLayout {
                id: city
                spacing: 15
                required property var modelData

                Text {
                    text: city.modelData.flag
                    font.pixelSize: 18
                }

                Text {
                    text: city.modelData.name
                    font.pixelSize: 18
                    color: Theme.colors.primaryText
                    font.family: "JetBrains Mono NFP"
                    Layout.fillWidth: true
                }

                Text {
                    id: timeText
                    text: (timeHitbox.containsMouse ? Time.getCrumbTime(city.modelData.utc)  + " — " : "") + Time.getFormattedTime(false, city.modelData.utc)
                    font.pixelSize: 18
                    font.bold: true
                    color: Theme.colors.purple
                    font.family: "JetBrains Mono NFP"

                    MouseArea {
                        id: timeHitbox
                        anchors.fill: parent
                        hoverEnabled: true
                    }
                }
            }
        }
    }
}