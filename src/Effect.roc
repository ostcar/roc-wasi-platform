hosted Effect
    exposes [
        Effect,
        after,
        map,
        always,
        forever,
        loop,
        stdoutLine,
        fileOpen,
    ]
    imports []
    generates Effect with [after, map, always, forever, loop]

stdoutLine : Str -> Effect {}
fileOpen : Str -> Effect (Result U64 U8)
