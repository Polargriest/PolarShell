import QtQuick
import QtQuick.Layouts
import qs.services
import qs.globals

ColumnLayout {
    Layout.preferredWidth: expanded.width
    Layout.preferredHeight: expanded.height
    Layout.alignment: Qt.AlignTop

    Column {
        id: expanded
        spacing: 1
        Layout.preferredWidth: 385

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
        Layout.bottomMargin: 25
    }
}