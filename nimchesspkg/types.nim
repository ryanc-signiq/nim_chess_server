## NimChess type definitions

const 
    aFile = 0x0101010101010101'u64
    hFile = 0x8080808080808080'u64
    topRow*  = 0x00000000000000FF'u64
    bottomRow* = 0xFF00000000000000'u64
    lightSquares = 0x55AA55AA55AA55AA'u64
    darkSquares = 0xAA55AA55AA55AA55'u64

type
    BitBoard* = distinct uint64

    ColorKind* {.pure.} = enum
        black, white

    PieceKind* {.pure.} = enum
        ## Available types that a Piece on a Board can be
        pawn,
        rook,
        knight,
        bishop,
        queen,
        king

    HelperBitBoardTypes* {.pure.} = enum
        black, white, all

    PieceBoard* = array[PieceKind.pawn..PieceKind.king, BitBoard]
    BitBoards* = array[ColorKind.black..ColorKind.white, PieceBoard]
    HelperBitBoards* = array[0..2, BitBoard] # Helper bitboards

    Piece* = ref object of RootObj
        ## A representation of a piece on a chess board
        kind*: PieceKind
        color*: ColorKind


