import QtQuick
import QtQuick.Shapes
import Qt5Compat.GraphicalEffects
import qs.globals
import qs.services

pragma ComponentBehavior: Bound

Item {
    id: root
    anchors.fill: parent

    property bool debugging: false

    required property real freeSpace
    required property real leftWidgetsSpace
    required property real rightWidgetsSpace

    Shape {
        anchors.fill: parent

        ShapePath {
            id: path
            fillColor: Theme.colorWithAlpha(Theme.colors.bg, Theme.colors.transparency)
            strokeColor: Theme.colors.bg
            strokeWidth: 2

            // --- MATH HELPERS ---
            readonly property real centerX: titleRectangle.middlePoint
            readonly property real halfTitle: titleRectangle.width / 2
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
    property bool showTitle: (appCase["show"] ?? true) && (freeSpace > Configs.bar.title.minWidth)

    function getApplicationCase(appClass, appTitle = "") {
        // TODO: this could have some clean up and upgraded functionability, like defaults rules per app

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

    // TODO: i don't want it to function using two debug rectangles.

    Rectangle { // FREE SPACE RECTANGLE
        width: root.freeSpace
        height: 30
        x: root.leftWidgetsSpace + 7.5

        visible: root.debugging
    }

    Rectangle { // FREE SPACE RECTANGLE
        id: titleRectangle

        property real middlePoint: x + width/2

        readonly property real idealX: (root.width / 2) - (width / 2)
        // ----------------------------------------------- // these three properties defines the title's boundaries
        readonly property real leftBoundary: root.leftWidgetsSpace + Configs.bar.title.marginsBetweenWidgets // STARTING point
        readonly property real availableWidth: rightBoundary - leftBoundary // the SPACE that it takes
        readonly property real rightBoundary: root.width - root.rightWidgetsSpace - Configs.bar.title.marginsBetweenWidgets // ENDING point

        width: Math.min(title.width, availableWidth) // cap the width to the available width if it overflows
        x: Math.max(leftBoundary, Math.min(idealX, rightBoundary - width)) // clamps the title offsetting from the middle (ideal X)

        // just visible if:
        // 1. available space is enough
        // 2. given space is acceptable by user
        // 3. not in debug mode
        visible: (root.freeSpace > Configs.bar.title.minWidth || width < root.freeSpace) && root.debugging

        height: 15
        color: "red"
    }

    Row {
        id: title
        visible: !root.debugging

        x: titleRectangle.x
        y: root.showTitle ? (root.height - 43) / 2 : -root.height/2 + 8
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

            text: root.title

            width: Math.min(contentWidth, titleRectangle.width - icon.width - title.spacing)

            readonly property real overflowingWidth: contentWidth - width
            readonly property bool isOverflowing: overflowingWidth > 0

            // STRENGTH CALCULATION:
            // We want the fade to start further back as more text is hidden.
            // 1.0 = No fade.
            // As overflowingWidth grows, we decrease this value.
            // We clamp it so it never fades more than 30% of the visible area.
            readonly property real fadeStart: {
                if (!isOverflowing) return 0.999;
                let factor = overflowingWidth / 150; // Adjust '150' to change how fast it reaches max fade
                return Math.max(0.9, 1.0 - (factor * 0.3));
            }

            // styling
            color: Theme.colors.primaryText
            font.bold: true
            font.pixelSize: 18
            font.family: "JetBrainsMono NFP Custom"
            horizontalAlignment: Text.AlignLeft
            clip: true

            MouseArea {
                anchors.fill: parent
                onClicked: console.log(Hyprland.activeToplevelTitle)
            }

            layer.enabled: true
            layer.effect: OpacityMask {
                maskSource: Item {
                    width: titleText.width
                    height: titleText.height

                    Rectangle {
                        anchors.fill: parent
                        gradient: Gradient {
                            orientation: Gradient.Horizontal
                            GradientStop { position: 0.0; color: "black" }
                            GradientStop { position: titleText.fadeStart; color: "black" }
                            GradientStop { position: 1.0; color: "transparent" }
                        }
                    }
                }
            }
        }
    }
}