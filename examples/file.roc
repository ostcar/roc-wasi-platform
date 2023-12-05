app "file"
    packages {
        pf: "../src/main.roc",
    }
    imports [
        pf.Task.{ Task },
        pf.File.{ FD },
    ]
    provides [main] to pf

main : Task {} I32
main = 

    result <- File.open "crash.roc" |> Task.attempt

    when result is 
        Ok _ -> Task.writeLine "SUCCESS opened file, opened crash.roc"
        Err UnableToOpenFile -> Task.writeLine "ERROR unable to file"
