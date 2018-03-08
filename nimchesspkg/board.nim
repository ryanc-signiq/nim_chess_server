import types, strutils, strformat

proc `==`*(x, y: BitBoard): bool {.borrow.}

proc `or`*(x, y: BitBoard): BitBoard {.borrow.}

proc `xor`*(x, y: BitBoard): BitBoard {.borrow.}

proc `and`*(x, y: BitBoard): BitBoard {.borrow.}

proc `shr`*(x: BitBoard, y: uint64): uint64 {.borrow.}

proc `shl`*(x: BitBoard, y: uint64): uint64 {.borrow.}

proc toBin*(x: BitBoard, len: Positive): string =
    toBin(BiggestInt(x), len)

proc toBin*(x: uint64, len: Positive): string =
    toBin(BiggestInt(x), len)

proc wrapBinBoard(s: string, split: int): string =
    result = ""
    var 
        counter = 0
        lastSplit = 0
    for c in s:
        counter.inc
        if counter %% split == 0 or counter == s.len:
            result.add(substr(s, lastSplit, counter - 1))
            inc(lastSplit, split)
            if counter < s.len:
                #More to split
                result.add('\n')

proc `$`*(x: BitBoard): string =
    result = wrapBinBoard(toBin(x, 64), 8)

{.push discardable.}  

proc initPawns(boards: var BitBoards, helperBoards: var HelperBitBoards) =
    ## Initialise all pawns on the board for available players
    ## 00000000
    ## XXXXXXXX
    ## 00000000
    ## 00000000
    ## 00000000
    ## 00000000
    ## XXXXXXXX
    ## 00000000
    ##
    boards[ColorKind.white][PieceKind.pawn] = BitBoard(topRow shl 8) #Generate for white pieces
    boards[ColorKind.black][PieceKind.pawn] = BitBoard(bottomRow shr 8) #Generate for black pieces

proc initHelpers(boards: var BitBoards, helperBoards: var HelperBitBoards) =
    ## Initialise all helper boards
    helperBoards[HelperBitBoardTypes.white] = BitBoard(topRow or (topRow shl 8))
    helperBoards[HelperBitBoardTypes.black] = BitBoard(bottomRow or (bottomRow shr 8))
    helperBoards[HelperBitBoardTypes.all] = helperBoards[HelperBitBoardTypes.white] or helperBoards[HelperBitBoardTypes.black]

proc initBishops(boards: var BitBoards, helperBoards: var HelperBitBoards) =
    ## Initialise our bishop boards
    ##
    ## 00X00X00
    ## 00000000
    ## 00000000
    ## 00000000
    ## 00000000
    ## 00000000
    ## 00000000
    ## 00X00X00
    ##
    boards[ColorKind.white][PieceKind.bishop] = BitBoard(topRow and 0x24'u64) #Generate for white pieces
    boards[ColorKind.black][PieceKind.bishop] = BitBoard(bottomRow and 0x2400000000000000'u64) #Generate for black pieces

proc initRooks(boards: var BitBoards, helperBoards: var HelperBitBoards) =
    ## Initialise our rooks boards
    ##
    ## X000000X
    ## 00000000
    ## 00000000
    ## 00000000
    ## 00000000
    ## 00000000
    ## 00000000
    ## X000000X
    ##
    boards[ColorKind.white][PieceKind.rook] = BitBoard(topRow and 0x71'u64) #Generate for white pieces
    boards[ColorKind.black][PieceKind.rook] = BitBoard(bottomRow and 0x7100000000000000'u64) #Generate for black pieces

proc initKnights(boards: var BitBoards, helperBoards: var HelperBitBoards) =
    ## Initialise our knights boards
    ##
    ## 0X0000X0
    ## 00000000
    ## 00000000
    ## 00000000
    ## 00000000
    ## 00000000
    ## 00000000
    ## 0X0000X0
    ##
    boards[ColorKind.white][PieceKind.knight] = BitBoard(topRow and 0x42'u64) #Generate for white pieces
    boards[ColorKind.black][PieceKind.knight] = BitBoard(bottomRow and 0x4200000000000000'u64) #Generate for black pieces

proc initQueens(boards: var BitBoards, helperBoards: var HelperBitBoards) =
    ## Initialise our queens boards
    ##
    ## 00000000
    ## 00000000
    ## 00000000
    ## 00000000
    ## 00000000
    ## 00000000
    ## 00000000
    ## 00000000
    ##
    boards[ColorKind.white][PieceKind.queen] = BitBoard(topRow and 0x10'u64) #Generate for white pieces
    boards[ColorKind.black][PieceKind.queen] = BitBoard(bottomRow and 0x1000000000000000'u64) #Generate for black pieces

proc initKings(boards: var BitBoards, helperBoards: var HelperBitBoards) =
    ## Initialise our kings boards
    ##
    ## 00000000
    ## 00000000
    ## 00000000
    ## 00000000
    ## 00000000
    ## 00000000
    ## 00000000
    ## 00000000
    ##
    boards[ColorKind.white][PieceKind.king] = BitBoard(topRow and 0x08'u64) #Generate for white pieces
    boards[ColorKind.black][PieceKind.king] = BitBoard(bottomRow and 0x0800000000000000'u64) #Generate for black pieces

proc initBoards*(boards: var BitBoards, helperBoards: var HelperBitBoards) =
    initPawns(boards, helperBoards) #Init our pawns
    initHelpers(boards, helperBoards) #Init our helper boards
    initBishops(boards, helperBoards) #Init our bishops
    initRooks(boards, helperBoards) #Init our rooks
    initKnights(boards, helperBoards) #Init our knights 
    initQueens(boards, helperBoards) #Init our queens 
    initKings(boards, helperBoards) #Init our kings 
    

{.pop.}

proc performMove*(state, update: BitBoard): BitBoard = 
    ## Works as such
    ## state is the current board state
    ## update is the board state afterwards
    state xor update    
