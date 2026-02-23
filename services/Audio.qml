import Quickshell
import Quickshell.Services.Pipewire
import QtQuick

pragma Singleton

/*
    AUDIO SERVICE
    -------------------------------------------------
    Using Pipewire's Quickshell integration, we create a simple API that can communicate with all our
    widgets. Here is a quick explanation on how Pipewire work:

    `Sinks` are output devices, like speakers. We can access the default output device with `Pipewire.defaultAudioSink`
        (yeah, I tought `Outputs` were a better name, but they are called Sinks because is where the info "drops" in the end).
    `Sources` are input devices, like microphones. We can access the default input device with `Pipewire.defaultAudioSource`
    `Streams` are more interesting. They represents an **application** that is sending sound trough a stream.

    Whether it's  a sink, a source, or audio, they are all **Nodes**. You can actually see your nodes using `pw-cli ls Node`.
    You will see your output devices, and if you are listening to music, your applications playing sounds aswell!

    To make a good Audio API, we need to access these nodes, filter them (as there are other node types that we don't need),
    expose them in a propery and create some util functions, like mute, change volume, etc.
*/

Singleton {
    id: root

    // To access Pipewire's nodes, we use `Pipewire.nodes`. This returns a Quickshell object called `ObjectModel` that is
    // like an iterator. But we want to access the **list** of the model, so we use the `values` property. Now, to filter
    // those nodes we don't want, we use the `reduce` function.
    readonly property var nodes: Pipewire.nodes.values.reduce(
        (acc, node) => { // so, for every node...
            if (!node.isStream) { // if node is NOT an stream (meaning is not an application)
                // it means it might be a sink or a source.
                if (node.isSink) {
                    acc.sinks.push(node);
                } else if (node.audio) {
                    acc.sources.push(node);
                }
            } else if (node.isStream && node.audio) {
                // However, some stream nodes can also be Input type. We should also filter these.
                if (node.properties["media.class"] !== "Stream/Input/Audio") {
                    acc.streams.push(node);
                }
            }

            return acc
        }, {
            // this will be the initial value of our `reduce` function (the first value `acc` will take when entering
            // the function): a dictionary of sources, sinks and streams array.
            sources: [],
            sinks: [],
            streams: []
        }
    )

    // however, by default, nodes do not update their values. So we need to explicitly say to Quickshell that we want
    // to track the properties of these nodes.
    PwObjectTracker {
        objects: Pipewire.nodes.values
    }

    // now we expose every node type as a property
    readonly property list<PwNode> sources: nodes.sources
    readonly property list<PwNode> sinks: nodes.sinks
    readonly property list<PwNode> streams: nodes.streams

    // defaults
    readonly property PwNode sink: Pipewire.defaultAudioSink
    readonly property PwNode source: Pipewire.defaultAudioSource

    // sink status
    readonly property bool muted: !!sink?.audio?.muted
    readonly property real volume: sink?.audio?.volume ?? 0
    // source status
    readonly property bool micMuted: !!source?.audio?.muted
    readonly property real micVolume: source?.audio?.volume ?? 0

    /////////////////////////// UTILITY FUNCTIONS /////////////////////////////

    // SINK FUNCTIONS:
    // These functions are utilities that changes behaviour on the default sink (the default output device)

    function setDefaultSink(sink: PwNode) {
        if (sink && sink?.ready) { // we ALWAYS need to ask if our sinker is ready
            Pipewire.preferredDefaultAudioSink = sink
        }
    }

    function toggleSinkMute() {
        if (sink?.ready && sink?.audio) { // we ALWAYS need to ask if our sinker is ready
            sink.audio.muted = !sink.audio.muted
        }
    }

    function setVolume(newVolume: real) {
        if (sink?.ready && sink?.audio) { // we ALWAYS need to ask if our sinker is ready
            sink.audio.muted = false
            sink.audio.volume = Math.max(0, Math.min(1, newVolume))
        }
    }

    function increaseVolume(amount: real) {
        setVolume(volume + amount)
    }

    function decreaseVolume(amount: real) {
        setVolume(volume - amount)
    }

    // NODE SPECIFIC FUNCTIONS:
    // These functions changes behaviour on the specified node (like application-specific).

    function getNodeMute(node: PwNode): bool {
        if (node?.ready && node?.audio) { // we ALWAYS need to ask if our sinker is ready
            return node.audio.muted
        }
    }

    function toggleNodeMute(node: PwNode) {
        if (node?.ready && node?.audio) { // we ALWAYS need to ask if our sinker is ready
            node.audio.muted = !node.audio.muted
        }
    }

    function setNodeVolume(node: PwNode, newVolume: real) {
        if (node?.ready && node?.audio) { // we ALWAYS need to ask if our sinker is ready
            node.audio.muted = false
            node.audio.volume = Math.max(0, Math.min(1, newVolume))
        }
    }

    // ------------------------------------------

    function toggleSourceMute() {
        if (source?.ready && source?.audio) { // we ALWAYS need to ask if our source is ready
            source.audio.muted = !source.audio.muted
        }
    }

    function setSourceVolume(newVolume: real) {
        if (source?.ready && source?.audio) { // we ALWAYS need to ask if our source is ready
            source.audio.muted = false
            source.audio.volume = Math.max(0, Math.min(1, newVolume))
        }
    }
}