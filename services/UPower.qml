import Quickshell.Services.UPower
import Quickshell

pragma Singleton

Singleton {
    readonly property double batteryPercentage: UPower.displayDevice.percentage
}