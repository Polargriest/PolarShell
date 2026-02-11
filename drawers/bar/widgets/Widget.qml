import QtQuick.Layouts
import QtQuick

ColumnLayout {
    id: root
    spacing: 10
    Layout.alignment: Qt.AlignTop // so it can expand downwards.

    property bool isOpen: false // whether if the clock is expanded or not.

    default property alias content: pillContainer.data

    ColumnLayout {
        id: pillContainer
        spacing: 10
        // This ensures the layout stays tight
        Layout.fillWidth: true
    }

    Keys.onEscapePressed: isOpen = false
}