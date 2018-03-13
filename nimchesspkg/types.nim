## NimChess type definitions
import tables

const 
    aFile = 0x0101010101010101'u64
    hFile = 0x8080808080808080'u64
    topRow*  = 0x00000000000000FF'u64
    bottomRow* = 0xFF00000000000000'u64
    lightSquares = 0x55AA55AA55AA55AA'u64
    darkSquares = 0xAA55AA55AA55AA55'u64
    RANKS*: Table[char, uint64] = {
        'a': 0'u64,
        'b': 1'u64,
        'c': 2'u64,
        'd': 3'u64,
        'e': 4'u64,
        'f': 5'u64,
        'g': 6'u64,
        'h': 7'u64
        }.toTable ## Maps ranks to how many 8-bit shifts they require

type
    BitBoard* = distinct uint64

    ColorKind* {.pure.} = enum
        Black = (0, "black"),
        White = (1, "white")


    PieceKind* {.pure.} = enum
        ## Available types that a Piece on a Board can be
        Pawn = "pawn",
        Rook = "rook",
        Knight = "knight",
        Bishop = "bishop"
        Queen = "queen"
        King = "king"

    HelperBitBoardTypes* {.pure.} = enum
        black, white, all

    PieceBoard* = array[PieceKind.Pawn..PieceKind.King, BitBoard]
    BitBoards* = array[ColorKind.Black..ColorKind.White, PieceBoard]
    HelperBitBoards* = array[HelperBitBoardTypes.black..HelperBitBoardTypes.all, BitBoard] # Helper bitboards

    Piece* = ref object of RootObj
        ## A representation of a piece on a chess board
        kind*: PieceKind
        color*: ColorKind


    Move* = tuple[rank: char, file: uint64]
    MoveVector* = tuple
        oldPos: Move
        newPos: Move
        piece: Piece
