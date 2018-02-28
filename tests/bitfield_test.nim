type

    bf = ref object of RootObj
        ## The current state of a chess board, a 64 bit bitfield
        field* {.bitsize:64.}: uint64

proc `<<=`*(a: var bf, b: uint64): uint64 =
    a.field = a.field shl b

proc `=>>`*(a: var bf, b: uint64): uint64 =
    a.field = a.field shr b

when isMainModule:
    var testbf = bf(field: 0xFFFFFFFFFFFFFFFF'u64)
    assert (testbf shr 1'u64 == 0x0FFFFFFFFFFFFFFF)

