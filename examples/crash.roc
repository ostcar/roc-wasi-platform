app "crash"
    packages {
        pf: "../src/main.roc",
    }
    imports []
    provides [main] to pf

main = crash "Roc crashed here.\n"
