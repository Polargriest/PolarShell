import QtQuick.Controls
import QtQuick.Layouts
import QtQuick

import Qt5Compat.GraphicalEffects

import qs.globals

Slider {
    id: slider
    clip: false
    Layout.fillWidth: true

    property color bgColor: Theme.colors.blue

    property color normalColor: bgColor
    property color bottomColor: Theme.multiplyColor(bgColor, 1.1)
    Behavior on normalColor { ColorAnimation { duration: Configs.bar.widgetsAnimations/3 } }
    Behavior on bottomColor { ColorAnimation { duration: Configs.bar.widgetsAnimations/3 } }

    hoverEnabled: true

    background: Item {
        implicitHeight: 30
        width: slider.availableWidth
        height: implicitHeight

        Rectangle {
            width: parent.width
            height: 15
            anchors.centerIn: parent
            radius: 100
            color: Theme.colors.bg
            border.width: 2
            border.color: Theme.colors.bgDark
        }

        Rectangle {
            implicitHeight: 15
            width: slider.handle.x + slider.handle.width / 2
            radius: 100

            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter

            gradient: Gradient {
                orientation: Gradient.Horizontal
                GradientStop { position: 0.0; color: slider.bottomColor }
                GradientStop { position: 1.0; color: slider.normalColor }
            }

            Behavior on color { ColorAnimation { duration: Configs.bar.widgetsAnimations/3 } }
        }
    }

    handle: Item {
        x: slider.leftPadding + slider.visualPosition * (slider.availableWidth - width)
        y: slider.topPadding + slider.availableHeight / 2 - height / 2
        implicitHeight: 30
        implicitWidth: 30

        DropShadow {
            anchors.fill: visualHandle
            radius: 18.0
            samples: 10
            color: Theme.colorWithAlpha(Theme.colors.bg, 0.5)
            source: visualHandle
        }

        Rectangle {
            id: visualHandle

            anchors.fill: parent
            radius: width / 2
            
            color: slider.bgColor
            border.width: slider.pressed ? 9 : slider.hovered ? 5 : 7
            Behavior on border.width { NumberAnimation { duration: 50 } }
            border.color: Theme.colors.primaryText
            Behavior on color { ColorAnimation { duration: Configs.bar.widgetsAnimations/3 } }
        }
    }

    wheelEnabled: true
}