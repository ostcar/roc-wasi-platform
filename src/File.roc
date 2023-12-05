interface File
    exposes [
        FD,
        open,
    ]
    imports [
        Effect,
        Task.{Task, fromEffect}
    ]

FD := U64

open : Str -> Task FD [UnableToOpenFile]
open = \path -> 
    Effect.fileOpen path
    |> Task.fromEffect
    |> Task.attempt \result ->

        when result is 
            Ok u64 -> Task.ok (@FD u64) # wrap the file descriptor
            Err _ -> Task.err UnableToOpenFile


