import Quickshell.Services.UPower
import Quickshell

pragma Singleton

Singleton {
    readonly property bool onBattery: UPower.displayDevice.isPresent
    readonly property double batteryPercentage: UPower.displayDevice.percentage
}