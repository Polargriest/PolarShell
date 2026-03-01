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

    // ---------- SHELL CONFIGS ----------
    readonly property QtObject shell: QtObject {
        // if your applications have icons in your NerdFonts, you can add them here.
        readonly property var appIcons: {
            "Zen": "",
        }
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

        // ---------- VOLUME WIDGET SETTINGS ----------
        readonly property QtObject audio: QtObject {
            readonly property real audioIncrement: 0.01 // how much should audio increase/decrease when scrolled with wheel.
        }

        // ---------- FETCH WIDGET SETTINGS ----------
        readonly property QtObject fetch: QtObject {
            readonly property real cpuUsageWarning: 60 // % of CPU usage where you want PolarShell to warn you.
            readonly property real cpuUsageCritical: 90 // % of CPU usage where you want PolarShell to mark as critic.

            readonly property real ramUsageWarning: 70 // % of RAM usage where you want PolarShell to warn you.
            readonly property real ramUsageCritical: 85 // % of RAM usage where you want PolarShell to mark as critic.

            readonly property real duWarning: 90 // % of disk usage where you want PolarShell to warn you.
            readonly property real duCritical: 95 // % of disk usage where you want PolarShell to mark as critic.

            // we can also warn you when you have lots of outdated packages. choose the thresholds.
            readonly property real outdatedPackagesWarning: 30
            readonly property real outdatedPackagesCritical: 60

            readonly property real usageUpdate: 2000 // in mms, how fast does usage statistics updates.
                                                     // NOTE: This updates even if the widget is closed, so go easy.

            // hides the github button, so you can stay with just with system options.
            readonly property bool hideGitHubButton: true
        }
    }
}