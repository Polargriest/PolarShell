import QtQuick
import QtQuick.Shapes
import QtQuick.Layouts
import qs.globals
import qs.services

Item {
    id: root
    anchors.fill: parent
    clip: true

    Shape {
        anchors.fill: parent

        ShapePath {
            id: path
            fillColor: Theme.colorWithAlpha(Theme.colors.bg, 0.6)
            strokeColor: Theme.colors.bg
            strokeWidth: 2

            // --- MATH HELPERS ---
            readonly property real centerX: root.width / 2
            readonly property real halfTitle: title.width / 2
            readonly property real strength: Configs.bar.title.curveSmoothness
            readonly property real marginOuter: Configs.bar.title.curveDistance * 2
            readonly property real marginInner: Configs.bar.title.curveDistance / 2

            // Sharp Corner Anchors
            readonly property real leftTop: centerX - halfTitle - marginOuter
            readonly property real leftBottom: centerX - halfTitle - marginInner
            readonly property real rightBottom: centerX + halfTitle + marginInner
            readonly property real rightTop: centerX + halfTitle + marginOuter

            property real pillBottom: root.showTitle ? root.height - 15 : Configs.bar.title.distanceFromTop
            Behavior on pillBottom { NumberAnimation { duration: 300; easing.type: Easing.InOutQuint } }

            // TODO: title pill position should adapt to the available space

            // --- THE PATH ---
            startX: -5; startY: 0
            PathLine { x: -5; y: Configs.bar.title.distanceFromTop }
            
            // 1. Move to start of Left Curve
            PathLine { x: path.leftTop - path.strength; y: Configs.bar.title.distanceFromTop }

            // 2. Left Descent
            PathCubic {
                x: path.leftBottom + path.strength; y: path.pillBottom
                
                control1X: path.leftTop + path.strength;    control1Y: Configs.bar.title.distanceFromTop
                control2X: path.leftBottom - path.strength; control2Y: path.pillBottom
            }

            // 3. Flat Bottom
            PathLine { x: path.rightBottom - path.strength; y: path.pillBottom }

            // 4. Right Ascent
            PathCubic {
                x: path.rightTop + path.strength; y: Configs.bar.title.distanceFromTop
                
                control1X: path.rightBottom + path.strength; control1Y: path.pillBottom
                control2X: path.rightTop - path.strength;    control2Y: Configs.bar.title.distanceFromTop
            }

            // 5. Finish
            PathLine { x: root.width + 5; y: Configs.bar.title.distanceFromTop }
            PathLine { x: root.width + 5; y: 0 }
        }
    }

    // -------------------------------------------------------------------

    property var appCase: getApplicationCase(Hyprland.activeToplevelClass, Hyprland.activeToplevelTitle)
    property string icon: appCase["icon"] ?? icon.text
    property string title: appCase["title"] ?? titleText.text
    property bool showTitle: appCase["show"] ?? true

    function getApplicationCase(appClass, appTitle = "") {
        //console.log(appClass + " | " + appTitle)
        let appFormats = Configs.shell.appFormats;

        if (!appClass) { return appFormats["_"] } // if no class, return catch-all
        if (!(appClass in appFormats)) { return { "icon": "[" + appClass[0].toUpperCase() + "]", "title": appTitle } } // if no specific case was determined for this app
        
        for (let pattern in appFormats[appClass]) { // check every pattern defined for that app class
            let regex = new RegExp(pattern);

            if (regex.test(appTitle)) { // check if the app title matches the pattern we are checking
                return {
                    "icon": appFormats[appClass][pattern]["icon"],
                    "title": appTitle.replace(regex, appFormats[appClass][pattern]["title"]),
                    "show": appFormats[appClass][pattern]["show"] ?? true
                }
            }
        }

        // if we checked every single posibility, let's check if it has a default
        if ("_" in appFormats[appClass]) {
            return {
                "icon": appFormats[appClass]["_"]["icon"] ?? appClass[0].toUpperCase(),
                "title": appTitle,
                "show": appFormats[appClass]["_"]["show"] ?? true
            }
        }

        return { "icon": "(" + appClass[0].toUpperCase() + ")", "title": appTitle }
    }

    Row {
        id: title
        y: root.showTitle ? (root.height - 43) / 2 : -root.height/2 + 8
        anchors.horizontalCenter: parent.horizontalCenter
        clip: true

        opacity: root.showTitle
        Behavior on y { NumberAnimation { duration: 300; easing.type: Easing.InOutQuint } }
        Behavior on opacity { NumberAnimation { duration: 300; easing.type: Easing.InOutQuint } }

        // --- DYNAMIC SPACING ---
        // If there's no icon text, spacing becomes 0 to maintain perfect center
        spacing: icon.text === "" ? 0 : 15

        width: icon.width + spacing + titleText.contentWidth
        Behavior on width {
            NumberAnimation {
                duration: 300
                easing.type: Easing.OutQuint
            }
        }

        Text {
            id: icon
            text: root.icon

            // styling
            color: Theme.colors.yellow
            font.bold: true
            font.pixelSize: 18
            font.family: "JetBrainsMono NFP Custom"

            MouseArea {
                anchors.fill: parent
                onClicked: console.log(Hyprland.activeToplevelClass)
            }
        }

        Text {
            id: titleText
            clip: true

            // TODO: title text should fade out when the title is longer than the available space.

            text: root.title

            width: title.width - icon.width - title.spacing

            // styling
            color: Theme.colors.primaryText
            font.bold: true
            font.pixelSize: 18
            font.family: "JetBrainsMono NFP Custom"

            horizontalAlignment: Text.AlignHCenter

            MouseArea {
                anchors.fill: parent
                onClicked: console.log(Hyprland.activeToplevelTitle)
            }
        }
    }
}