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
        // if you want to format your own apps icons and titles, change this option! Here we include a small
        // tutorial on how to add your own apps.
        readonly property var appFormats: {
            // "app-class": {
            //     "title regex": {     // can also be "_" for a catch-all // these are checked from top to bottom.
            //         "icon": "X",
            //         "title": "Window Title"   // it will replace the title regex, so you can use $1, $2...
            //     }
            // }

            // plain apps: just renames and icons
            "steam": { "(.*)": { "icon": "", "title": "$1" } },
            "hyprland-share-picker": { "(.*)": { "icon": "", "title": "Select screen to share" } },
            "modrinth-app-wrapped": { "(.*)": { "icon": "[M]", "title": "$1" } },
            "org.vinegarhq.Sober": { "(.*)": { "icon": "", "title": "$1" } },
            "sober": { "(.*)": { "icon": "", "title": "$1" } },
            "krita": { "(.*)": { "icon": "", "title": "$1" } },
            "ONLYOFFICE": { "(.*)": { "icon": "󰏆", "title": "$1" } },
            "jetbrains-studio": { "(.*)": { "icon": "󰀴", "title": "$1" } },

            // simple renames: probably just to remove a dash
            "code": { "(.*) - Visual Studio Code": { "icon": "󰨞", "title": "$1" }, "(.*)": { "icon": "󰨞", "title": "$1" } },
            "discord": { "(.*) - Discord": { "icon": "", "title": "$1" } },
            "org.kde.dolphin": { "(.*) — Dolphin": { "icon": "", "title": "$1" } },
            "dotnet": { "Terraria: (.*)": { "icon": "󰔱", "title": "Terraria: $1" } },

            // heavy renames: behaves different depending on title
            "zen": {
                "(.*) WhatsApp — Zen Browser": { "icon": "<font color='" + Theme.colors.green + "''></font>", "title": "WhatsApp $1" },
                "(.*) - Google Search — Zen Browser": { "icon": "<font color='" + Theme.colors.blue + "''></font>", "title": "<i>\"$1\"</i>" },
                "(.*) - YouTube — Zen Browser": { "icon": "<font color='" + Theme.colors.red + "''></font>", "title": "$1" },
                "(.*) - T3 Chat — Zen Browser": { "icon": "<font color='" + Theme.colors.purple + "''>󰭹</font>", "title": "$1" },
                "(.*) — Zen Browser": { "icon": "", "title": "$1" },
                "_": { "icon": "" }
            },

            "kitty": {
                "scrcpy": { "icon": "", "title": "scrcpy" },
                "(.*)": { "icon": "", "title": "$1" }
            },

            "obsidian": {
                "(.*) - (.*) - Obsidian (.*)": { "icon": "", "title": "$1" },
                "(.*)": { "icon": "", "title": "$1" }
            },


            "_": { "show": false } // if we really can't determine where you are, this is the default.
        }

        // change your shell style with other popular themes! Add your own ones or modify them on the Theme.qml
        // file. Initially, it supports the following values:

        // Theme.monokai: https://monokai.pro/
        // Theme.catpuccin: https://catppuccin.com/palette/ (Mocha)
        // Theme.synthwave84: https://marketplace.visualstudio.com/items?itemName=RobbOwen.synthwave-vscode
        // Theme.dracula: https://github.com/dracula/dracula-theme
        // Theme.gruvbox: https://github.com/morhetz/gruvbox
        readonly property QtObject theme: Theme.monokai
    }

    // -------------------------------------------------------------------

    // ---------- BAR CONFIGS ----------
    readonly property QtObject bar: QtObject {

        readonly property int height: 50 // how much space will Quickshell reserve for the bar.
        readonly property int widgetsAnimations: 600 // time (in ms) that the bar animations will take.
        readonly property int pillMargins: 15 // how many pixels should every pill have.
        // TODO: position config so you can move the bar to the bottom. That would be fun.

        // ---------- TITLE SETTINGS ----------
        readonly property QtObject title: QtObject {
            // change the title pill style! Available options are "Notch", "Classic" and "Floating"
            readonly property string style: "Notch"

            // Configurations for EVERY stle
            readonly property real marginsBetweenWidgets: 50 // space that title will leave between widgets

            // Configurations for NOTCH stle
            readonly property real curveDistance: 13 // how far from the actual window title will the notch start curving.
            readonly property real curveSmoothness: 15 // indicates how smooth do you want the notch curves to be.
            readonly property real distanceFromTop: 7 // how much space does you want the top rectangle to take.
            readonly property real minWidth: 300 // if the space available is less than this, the title will hide. 
        }

        // ---------- CLOCK WIDGET SETTINGS ----------
        readonly property QtObject clock: QtObject {
            readonly property bool use12hrs: true // which format do you want the clock to show (turn off for 24hrs)
            readonly property string calendarLocalization: "en_US" // localization that will be use for the calendar pill.

            readonly property var worldClockCities: [
                { flag: "🇺🇸", name: "Hickory", utc: -4 },
                { flag: "🌐", name: "UTC", utc: 0 },
            ] // cities you want world clock to show. Leave empty to hide this widget.
        }

        // ---------- VOLUME WIDGET SETTINGS ----------
        readonly property QtObject audio: QtObject {
            readonly property real audioIncrement: 0.01 // how much should audio increase/decrease when scrolled with wheel.
        }

        // ---------- FETCH WIDGET SETTINGS ----------
        readonly property QtObject fetch: QtObject {
            // TODO: make fetch modules customizable

            // hides the github button, so you can stay with just with system options.
            readonly property bool hideGitHubButton: true
            // minimun width. Increase for better battery progress bar visibility. It will never cut the icons.
            readonly property real fetchMinWidth: 50

            // PolarShell tracks your system health (CPU, RAM, disk, and packages). Even when closed, it'll alert
            // you with icons if things look abnormal. Set your preferred warning and critical thresholds below!

            readonly property real cpuUsageWarning: 60
            readonly property real cpuUsageCritical: 90

            readonly property real ramUsageWarning: 70
            readonly property real ramUsageCritical: 85

            readonly property real duWarning: 90
            readonly property real duCritical: 95

            readonly property real outdatedPackagesWarning: 30
            readonly property real outdatedPackagesCritical: 60

            // in mms, how fast does usage statistics updates.
            // NOTE: This updates even if the widget is closed, so go easy.
            readonly property real usageUpdate: 2000

            // ---------- BATTERY SETTINGS ----------
            // Most of these options will only have effect if you are on battery.
            readonly property bool showPercentage: false // Toggle battery percentage or icons in fetch widget.
            readonly property bool showSymbol: true // Toggle the "%" after the battery percentage.
            readonly property bool showProgressBar: true // Toggle background battery percentage bar in fetch widget.
            readonly property real lowBattery: 20 // % of battery where you want to appear as red.

        }
    }
}
