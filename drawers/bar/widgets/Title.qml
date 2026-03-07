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
            readonly property real strength: Configs.bar.titleCurveStrength
            readonly property real marginOuter: Configs.bar.titleMargins * 2
            readonly property real marginInner: Configs.bar.titleMargins / 2

            // Sharp Corner Anchors
            readonly property real leftTop: centerX - halfTitle - marginOuter
            readonly property real leftBottom: centerX - halfTitle - marginInner
            readonly property real rightBottom: centerX + halfTitle + marginInner
            readonly property real rightTop: centerX + halfTitle + marginOuter

            // --- THE PATH ---
            startX: -5; startY: 0
            PathLine { x: -5; y: 10 }
            
            // 1. Move to start of Left Curve
            PathLine { x: path.leftTop - path.strength; y: 10 }

            // 2. Left Descent
            PathCubic {
                x: path.leftBottom + path.strength; y: root.height - 15
                
                control1X: path.leftTop + path.strength;    control1Y: 10
                control2X: path.leftBottom - path.strength; control2Y: root.height - 15
            }

            // 3. Flat Bottom
            PathLine { x: path.rightBottom - path.strength; y: root.height - 15 }

            // 4. Right Ascent
            PathCubic {
                x: path.rightTop + path.strength; y: 10
                
                control1X: path.rightBottom + path.strength; control1Y: root.height - 15
                control2X: path.rightTop - path.strength;    control2Y: 10
            }

            // 5. Finish
            PathLine { x: root.width + 5; y: 10 }
            PathLine { x: root.width + 5; y: 0 }
        }
    }

    Row {
        id: title
        y: (root.height - 43) / 2
        anchors.horizontalCenter: parent.horizontalCenter
        clip: true

        // --- DYNAMIC SPACING ---
        // If there's no icon text, spacing becomes 0 to maintain perfect center
        spacing: icon.text === "" ? 0 : 20

        width: icon.width + spacing + titleText.contentWidth
        Behavior on width {
            NumberAnimation {
                duration: 300
                easing.type: Easing.OutQuint
            }
        }

        Text {
            id: icon
            text: {
                let app = Hyprland.activeToplevel?.wayland?.appId ?? "null"
                return Configs.shell.appIcons[app] ?? ""
            }

            // styling
            color: Theme.colors.yellow
            font.bold: true
            font.pixelSize: 18
            font.family: "JetBrainsMono NFP Custom"            
        }

        Text {
            id: titleText
            clip: true

            function getFormattedTitle(rawTitle) {
                if (!rawTitle) return "Desktop";
                
                let rewrites = Configs.shell.appRewrites;
                
                // Iterate through the keys (the regex strings)
                for (let pattern in rewrites) {
                    let regex = new RegExp(pattern);
                    if (regex.test(rawTitle)) {
                        // Use the value from the config as the replacement string
                        // String.replace supports $1, $2 capture groups automatically
                        return rawTitle.replace(regex, rewrites[pattern]);
                    }
                }
                
                return rawTitle; // Return original if no match found
            }

            readonly property string displayTitle: getFormattedTitle(Hyprland.activeToplevel ? Hyprland.activeToplevel.title : "")

            text: displayTitle

            width: title.width - icon.width - title.spacing

            // styling
            color: Theme.colors.primaryText
            font.bold: true
            font.pixelSize: 18
            font.family: "JetBrainsMono NFP Custom"

            horizontalAlignment: Text.AlignHCenter
        }
    }
}