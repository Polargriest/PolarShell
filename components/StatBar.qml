import QtQuick.Controls
import QtQuick.Layouts
import QtQuick

import qs.globals

Slider {
    id: slider
    enabled: false

    property color bgColor: Theme.colors.blue

    Layout.fillWidth: true
    Layout.preferredHeight: 35

    background: Rectangle {
        implicitHeight: 35
        width: slider.availableWidth
        radius: 7

        color: Theme.colorWithAlpha(Theme.colors.bgDark, "0.5")

        Rectangle {
            // This creates a 6px gap on all sides
            anchors {
                left: parent.left
                top: parent.top
                bottom: parent.bottom
                margins: 4 // This is your padding
            }

            width: (parent.width - (anchors.margins * 2)) * slider.visualPosition
            radius: 4

            anchors.right: undefined

            color: slider.bgColor

            Behavior on width {
                NumberAnimation {
                    duration: 500
                    easing.type: Easing.OutQuad
                }
            }
        }
    }

    handle: Item {}
}