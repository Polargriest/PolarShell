import QtQuick.Layouts
import QtQuick

ColumnLayout {
    id: root
    spacing: 10
    Layout.alignment: alignment // so it can expand downwards.

    property bool isOpen: false // whether if the clock is expanded or not.

    property int alignment: parent ? parent.Layout.alignment : Qt.AlignLeft

    default property alias content: pillContainer.data

    ColumnLayout {
        id: pillContainer
        spacing: 10
        // This ensures the layout stays tight
        Layout.fillWidth: true
    }
}