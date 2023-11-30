app "helloworld"
    packages {
        pf: "../../src/main.roc",
    }
    imports [
        pf.Task.{ Task },
    ]
    provides [main] to pf

main : Task {} I32
main = 
    Task.writeLine "hello world"
