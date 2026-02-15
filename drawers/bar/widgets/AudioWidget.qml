import QtQuick
import qs.services
import qs.globals
import "audio"

Widget {
    id: widget

    WidgetPill {
        id: leaderPill
        expanded: widget.isOpen

        property real volume: 100

        collapsedView: CollapsedAudio {}
        expandedView: ExpandedAudio {}

        MouseArea {
            id: hitbox
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor

            acceptedButtons: Qt.LeftButton | Qt.RightButton
            onClicked: (event) => {
                if (event.button === Qt.RightButton && !widget.isOpen) {
                    Audio.toggleSinkMute()
                } else if (event.button === Qt.LeftButton) {
                    widget.isOpen = !widget.isOpen
                }
            }

            onWheel: event => {
                if (event.angleDelta.y > 0) {
                    Audio.increaseVolume(Configs.bar.audio.audioIncrement)
                } else {
                    Audio.decreaseVolume(Configs.bar.audio.audioIncrement)
                }
            }
        }
    }
}