import types

template FirstOne (x: uint64): uint64 = 
    BitScanDatabase[(((x) and-(x)) * BITSCAN_MAGIC) rsh 58]

proc initializeFirstOne*(): void = 
    var bit:uint64 = 1
    var i = 1
    while bit > uint64(0):
        BitScanDatabase[uint64((bit * BITSCAN_MAGIC) >> 58)] = i
        i.inc
        bit <<= uint64(1)
