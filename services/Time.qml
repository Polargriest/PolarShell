import Quickshell
import QtQuick
import qs.globals

pragma Singleton

// TIME SERVICE
// we use SystemClock to get time & date. This file also declare some utils functions.

Singleton {
    // raw date, straight from SystemClock
    readonly property date now: clock.date

    function applyUTC(datetime: date, utc: int): date {
        // first, we getTime(). That converts `now` into Unix Time. However, we now need to add the offset of our
        // time zone to "normalize" the time. To do so, we ask how much offset (in minutes) our timezone has to UTC+0
        // and convert that to milliseconds multiplying by 60,000
        let normalizedTime = now.getTime() + (now.getTimezoneOffset() * 60000);

        // now, we create our new Date object using our normalized time but adding how many milliseconds we want to shift.
        // using the advantage that we have UTC+0, we just add how many hours our timezone is away from it.
        let newDate = new Date(normalizedTime + (utc * 3600000));

        return newDate
    }

    // returns the time formatted. You can specify if you want to show the seconds. It also handles the 12-24
    // hour format specified in the config file.
    function getFormattedTime(seconds: bool, utc = undefined): string {
        let use12hrs = Configs.bar.clock.use12hrs;
        let date_string = "hh:mm" + (seconds ? ":ss" : "") + (use12hrs ? " AP" : "")

        if (utc !== undefined) {
            return Qt.formatDateTime(applyUTC(now, utc), date_string);
        }

        return Qt.formatDateTime(now, date_string)
    }

    // recieve a day number and return their ordinal.
    function getOrdinal(d: int): string {
        if (d > 3 && d < 21) return 'th'; // because 11th, 12th & 13th are exceptions
        switch (d % 10) {
            case 1: return "st";
            case 2: return "nd";
            case 3: return "rd";
            default: return "th";
        }
    }

    // returns the date formatted like: "Sun 1"
    function getCrumbTime(utc = undefined): string {
        let date_string = "ddd d"

        if (utc !== undefined) {
            return Qt.formatDateTime(applyUTC(now, utc), date_string);
        }

        return Qt.formatDateTime(now, date_string)
    }

    // returns the date formatted like: "Sunday, 1st February 2026"
    function getFormattedDate(): string {
        let date = Time.now
        let dayNum = Qt.formatDateTime(Time.now, "d")

        return Qt.formatDateTime(date, "dddd, MMMM d'" + getOrdinal(parseInt(dayNum)) + "', yyyy")
    }

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }
}