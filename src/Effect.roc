hosted Effect
    exposes [
        Effect,
        after,
        map,
        always,
        forever,
        loop,
        stdoutLine
    ]
    imports []
    generates Effect with [after, map, always, forever, loop]

stdoutLine : Str -> Effect {}
