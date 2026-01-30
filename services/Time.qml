import Quickshell
import QtQuick

pragma Singleton

// TIME SERVICE
//
// usando SystemClock, formateamos la hora.

Singleton {
    // en esta string guardamos la hora. Esta propiedad puede ser leída en otros lados (como en ClockWidget)
    readonly property string time: {
        Qt.formatDateTime(clock.date, "hh:mm AP")
    }

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }
}