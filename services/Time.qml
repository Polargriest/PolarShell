import Quickshell
import QtQuick

pragma Singleton

// TIME SERVICE
//
// usando SystemClock, formateamos la hora.

Singleton {
    // en esta string guardamos la hora. Esta propiedad puede ser leída en otros lados (como en ClockWidget)
    readonly property string now: clock.date

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }
}