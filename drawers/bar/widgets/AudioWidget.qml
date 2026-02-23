pragma ComponentBehavior: Bound

import QtQuick
import qs.services
import qs.globals
import "audio"

Widget {
    id: widget

    WidgetPill {
        id: leaderPill
        expanded: widget.isOpen

        collapsedView: CollapsedAudio {}
        expandedView: ExpandedAudio { 
            id: expandedAudio
        }

        property bool mouseInSlider: leaderPill.expandedItem ? leaderPill.expandedItem.slideHovered : false
        property bool mouseInMute: leaderPill.expandedItem ? leaderPill.expandedItem.muteHovered : false
        property bool mouseInMicSlider: leaderPill.expandedItem ? leaderPill.expandedItem.slideMicHovered : false
        property bool mouseInMicMute: leaderPill.expandedItem ? leaderPill.expandedItem.muteMicHovered : false

        MouseArea {
            id: hitbox
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor

            propagateComposedEvents: true
            acceptedButtons: Qt.LeftButton | Qt.RightButton

            onPressed: (event) => {
                if (leaderPill.mouseInSlider || leaderPill.mouseInMute || leaderPill.mouseInMicSlider || leaderPill.mouseInMicMute) event.accepted = false
            }

            onClicked: (event) => {
                if (event.button === Qt.RightButton && !widget.isOpen) {
                    Audio.toggleSinkMute()
                } else if (event.button === Qt.LeftButton) {
                    widget.isOpen = !widget.isOpen
                }
            }

            onWheel: event => {
                if (leaderPill.mouseInSlider || leaderPill.mouseInMute || leaderPill.mouseInMicSlider || leaderPill.mouseInMicMute) event.accepted = false
                if (widget.isOpen) return

                if (event.angleDelta.y > 0) {
                    Audio.increaseVolume(Configs.bar.audio.audioIncrement)
                } else {
                    Audio.decreaseVolume(Configs.bar.audio.audioIncrement)
                }
            }
        }
    }

    OutputPill {
        expanded: widget.isOpen
        leaderPill: leaderPill
    }

    MixerPill {
        expanded: widget.isOpen
        leaderPill: leaderPill
    }
}