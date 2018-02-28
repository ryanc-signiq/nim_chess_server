# Package

version       = "0.1.0"
author        = "Ryanc_signiq"
description   = "Nim implementation of a chess game"
license       = "MIT"

# Dependencies

requires "nim >= 0.17.2"
requires "jester >= 0.2.0"
requires "contracts >= 0.1.0"
bin = @["nimchess"]

skipDirs = @["tests", "private"]

task run, "Build and run project":
    exec "nim c -r --out:bin/nimchess src/nimchess.nim"

task docs, "Build all the docs":
    exec "nim doc --out:docs/nimchess.html src/nimchess.nim"

task test, "Test Project":
    exec "nim c -r --out:bin/tests tests/bitfield_tests"
