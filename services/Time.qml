import Quickshell
import QtQuick
import qs.globals

pragma Singleton

// TIME SERVICE
// we use SystemClock to get time & date. This file also declare some utils functions.

Singleton {
    // raw date, straight from SystemClock
    readonly property string now: clock.date

    // returns the time formatted. You can specify if you want to show the seconds. It also handles the 12-24
    // hour format specified in the config file.
    function get_formatted_time(seconds: bool): string {
        let use_12hrs = Configs.bar.clock_widget.use_12hrs;
        let date_string = "hh:mm" + (seconds ? ":ss" : "") + (use_12hrs ? " AP" : "")

        return Qt.formatDateTime(now, date_string)
    }

    // recieve a day number and return their ordinal.
    function get_ordinal(d: int): string {
        if (d > 3 && d < 21) return 'th'; // because 11th, 12th & 13th are exceptions
        switch (d % 10) {
            case 1: return "st";
            case 2: return "nd";
            case 3: return "rd";
            default: return "th";
        }
    }

    // returns the date formatted like: "Sunday, 1st February 2026"
    function get_formatted_date(): string {
        let date = Time.now
        let dayNum = Qt.formatDateTime(Time.now, "d")

        return Qt.formatDateTime(date, "dddd, MMMM d'" + get_ordinal(parseInt(dayNum)) + "', yyyy")
    }

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }
}