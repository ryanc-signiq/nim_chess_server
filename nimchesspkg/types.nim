## NimChess type definitions

type
    BoardState* = ref object of RootObj
        ## The current state of a chess board, a 64 bit bitfield
        field {.bitsize:64.}: culonglong

    PieceKind*  {.pure.} = enum
        ## Available types that a Piece on a Board can be
        pawn,
        rook,
        knight,
        bishop,
        queen,
        king

    ColorKind* {.pure.} = enum
        Black, White

    Piece* = ref object of RootObj
        ## A representation of a piece on a chess board
        kind*: PieceKind
        color*: ColorKind
