import types

proc `==`*(x, y: BitBoard): bool {.borrow.}

proc `$`*(x: BitBoard): string {.borrow.}

{.push discardable.}  

proc initPawns(boards: var BitBoards, helperBoards: var HelperBitBoards) =
    ## Initialise all pawns on the board for available players
    boards[ColorKind.white][PieceKind.pawn] = BitBoard(topRow shl 8) #Generate for white pieces
    boards[ColorKind.black][PieceKind.pawn] = BitBoard(bottomRow shr 8) #Generate for black pieces

#proc initBishops(boards: var BitBoards, helperBoards: var HelperBitBoards) =

#proc initRooks(boards: var BitBoards, helperBoards: var HelperBitBoards) =
#
#proc initKnights(boards: var BitBoards, helperBoards: var HelperBitBoards) =
#
#proc initQueens(boards: var BitBoards, helperBoards: var HelperBitBoards) =
#
#proc initKings(boards: var BitBoards, helperBoards: var HelperBitBoards) =
#
proc initBoards*(boards: var BitBoards, helperBoards: var HelperBitBoards) =
    initPawns(boards, helperBoards) #Init our pawns
    

{.pop.}

