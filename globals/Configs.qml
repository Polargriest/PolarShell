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
        readonly property int pillMargins: 15 // how many pixels should every pill have.
        // TODO: position config so you can move the bar to the bottom. That would be fun.

        // ---------- CLOCK WIDGET SETTINGS ----------
        readonly property QtObject clock: QtObject {
            readonly property bool use12hrs: true // which format do you want the clock to show (turn off for 24hrs)
            readonly property string calendarLocalization: "en_US" // localization that will be use for the calendar pill.

            readonly property var worldClockCities: [
                { flag: "🇺🇸", name: "Hickory", utc: -5 },
                { flag: "🇯🇵", name: "Tokyo", utc: 9 }
            ] // cities you want world clock to show. Leave empty to hide this widget.
        }
    }
}