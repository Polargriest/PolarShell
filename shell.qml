import Quickshell
import "drawers"
import "services"

/*
    /!\ WARNING
    ----------------------------------------------
    this codebase is INHUMANLY COMMENTED. this is because I was learning Quickshell and QML and wanted to write down
    everything I learnt. If you are a completly begginner just like me, this codebase might help you a lot!! (keep in
    mind that I might not have the best practices tho, but I'm still learning).

    `shell.qml` is the entry point for Quickshell
    we can use ShellRoot as a starting object for Quickshell. This object also allows writing some settings inline.


    [!] NOTE
    ---------------------------------------------
    my code is HEAVILY inspired by the Caelestia shell. Some code structure I borrowed it from there. It helped me to
    learn a lot quicker!! Check the project out: https://github.com/caelestia-dots/shell
*/

ShellRoot {
    Drawers {} // check drawers/Drawers.qml
}