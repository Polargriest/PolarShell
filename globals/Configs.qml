import Quickshell
import QtQuick

pragma Singleton

Singleton {
    // ---------- SCREEN CONFIGS ----------
    readonly property QtObject screen: QtObject {
        // in Hyprland, size of the gap between the edges of the screen and the windows. This value is used
        // to leave a margin bewtween the top of the screen and the bar.
        readonly property int gapsOut: 15
    }

    // -------------------------------------------------------------------

    // ---------- BAR CONFIGS ----------
    readonly property QtObject bar: QtObject {

        readonly property int height: 50 // how much space will Quickshell reserve for the bar.
        readonly property int widgetsAnimations: 600 // time (in ms) that the bar animations will take.
        // TODO: position config so you can move the bar to the bottom. That would be fun.

        // ---------- CLOCK WIDGET SETTINGS ----------
        readonly property QtObject clock: QtObject {
            readonly property bool use12hrs: true // which format do you want the clock to show (turn off for 24hrs)
        }
    }
}