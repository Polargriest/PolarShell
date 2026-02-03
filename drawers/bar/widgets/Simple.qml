import QtQuick.Layouts
import QtQuick
import qs.globals

Rectangle {
    id: calendar

    Layout.alignment: Qt.AlignRight

    width: 200
    height: 200

    // appearence
    color: Theme.colorWithAlpha(Theme.colors.bg, 0.6)
    radius: 17
    border.width: 2
    border.color: Theme.colors.bg
    clip: true // masks the overflowing components.

    Text {
        Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
        color: Theme.colors.textColor
        text: "Hola"
    }
}