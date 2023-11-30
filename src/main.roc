platform "wasi"
    requires {} { main : Task {} I32 }
    exposes [
        Task,
    ]
    packages {}
    imports [Task.{ Task }]
    provides [mainForHost]

mainForHost : Task {} I32 as Fx
mainForHost = main
