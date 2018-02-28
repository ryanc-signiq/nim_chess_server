## NimChess type definitions

type
    BitBoardUint = distinct uint64

    BoardState* = ref object of RootObj
        ## The current state of a chess board, a 64 bit bitfield
        field {.bitsize:64.}: BitBoardUint

    PieceKind*  {.pure.} = enum
        ## Available types that a Piece on a Board can be
        pawn,
        rook,
        knight,
        bishop,
        queen,
        king

    BitScanDatabaseType* = distinct array[0..63, uint]

    ColorKind* {.pure.} = enum
        Black, White

    Piece* = ref object of RootObj
        ## A representation of a piece on a chess board
        kind*: PieceKind
        color*: ColorKind

const BITSCAN_MAGIC* = 0x07EDD5E59A4E28C2'u64

proc `<<=`*(a: var uint64, b: uint64): uint64 =
    a = a shl b

var BitScanDatabase*: BitScanDatabaseType

proc `[]`*(bst: var BitScanDatabaseType, val: uint): 
