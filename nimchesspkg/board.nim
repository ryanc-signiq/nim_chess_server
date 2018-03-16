import types, strutils, strformat, json, tables

proc toBin*(x: BitBoard, len: Positive): string =
    ## Converts a BitBoard to a binary string
    toBin(BiggestInt(x), len)

proc toBin*(x: uint64, len: Positive): string =
    ## Converts a uint64 to a binary string
    toBin(BiggestInt(x), len)

proc wrapBinBoard(s: string, split: int): string =
    ## Wraps a bitboard into an 8x8 string representation
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

proc `==`*(x, y: BitBoard): bool {.borrow.}

proc `or`*(x, y: BitBoard): BitBoard {.borrow.}

proc `not`*(x: BitBoard): BitBoard {.borrow.}

proc `xor`*(x, y: BitBoard): BitBoard {.borrow.}

proc `and`*(x, y: BitBoard): BitBoard {.borrow.}

proc `and`*(x: BitBoard, y: uint64): BitBoard {.borrow.}

proc `shr`*(x: BitBoard, y: uint64): uint64 {.borrow.}

proc `shl`*(x: BitBoard, y: uint64): uint64 {.borrow.}

proc `$`*(x: BitBoard): string =
    ## Prints a BitBoard as an 8x8 binary string
    result = wrapBinBoard(toBin(x, 64), 8)

proc splitCoordinates(rankfile: string): Move =
    ## Splits a Rank/File string (ie A5, C7)
    (rankfile[0], uint64(parseInt($rankfile[1])))


proc initMoveVector*(data: JsonNode): MoveVector =
    ## Builds a Movement Vector from a JSON message
    var 
        smv, emv: Move
        color: ColorKind
        piecekind: PieceKind
        piece: Piece
    if data.hasKey("smv") and data.hasKey("emv"):
        smv = splitCoordinates(data["smv"].getStr())
        emv = splitCoordinates(data["emv"].getStr())
    else:
        raise newException(KeyError, "Missing Start/End Coordinates")

    if data.hasKey("color"):
        case data["color"].getStr():
            of $ColorKind.White:
                color = ColorKind.White
            of $ColorKind.Black:
                color = ColorKind.Black
            else:
                raise newException(KeyError, "Missing Color Kind")
                
    if data.hasKey("piece"):
        case data["piece"].getStr():
            of $PieceKind.Pawn:
                piecekind = PieceKind.Pawn
            of $PieceKind.Knight:
                piecekind = PieceKind.Knight
            of $PieceKind.Rook:
                piecekind = PieceKind.Rook
            of $PieceKind.Bishop:
                piecekind = PieceKind.Bishop
            of $PieceKind.Queen:
                piecekind = PieceKind.Queen
            of $PieceKind.King:
                piecekind = PieceKind.King
            else:
                raise newException(KeyError, "Missing Piece Kind")

    piece = Piece(color: color, kind: piecekind)
    result = (oldPos: smv, newPos: emv, piece: piece)

proc initMoveVector*(data: string): MoveVector =
    initMoveVector(parseJson(data))

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
    boards[ColorKind.White][PieceKind.Pawn] = BitBoard(topRow shl 8) #Generate for white pieces
    boards[ColorKind.Black][PieceKind.Pawn] = BitBoard(bottomRow shr 8) #Generate for black pieces

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
    boards[ColorKind.White][PieceKind.Bishop] = BitBoard(topRow and 0x24'u64) #Generate for white pieces
    boards[ColorKind.Black][PieceKind.Bishop] = BitBoard(bottomRow and 0x2400000000000000'u64) #Generate for black pieces

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
    boards[ColorKind.White][PieceKind.Rook] = BitBoard(topRow and 0x71'u64) #Generate for white pieces
    boards[ColorKind.Black][PieceKind.Rook] = BitBoard(bottomRow and 0x7100000000000000'u64) #Generate for black pieces

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
    boards[ColorKind.White][PieceKind.Knight] = BitBoard(topRow and 0x42'u64) #Generate for white pieces
    boards[ColorKind.Black][PieceKind.Knight] = BitBoard(bottomRow and 0x4200000000000000'u64) #Generate for black pieces

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
    boards[ColorKind.White][PieceKind.Queen] = BitBoard(topRow and 0x10'u64) #Generate for white pieces
    boards[ColorKind.Black][PieceKind.Queen] = BitBoard(bottomRow and 0x1000000000000000'u64) #Generate for black pieces

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
    boards[ColorKind.White][PieceKind.King] = BitBoard(topRow and 0x08'u64) #Generate for white pieces
    boards[ColorKind.Black][PieceKind.King] = BitBoard(bottomRow and 0x0800000000000000'u64) #Generate for black pieces

proc initBoards*(boards: var BitBoards, helperBoards: var HelperBitBoards) =
    initPawns(boards, helperBoards) #Init our pawns
    initHelpers(boards, helperBoards) #Init our helper boards
    initBishops(boards, helperBoards) #Init our bishops
    initRooks(boards, helperBoards) #Init our rooks
    initKnights(boards, helperBoards) #Init our knights 
    initQueens(boards, helperBoards) #Init our queens 
    initKings(boards, helperBoards) #Init our kings 
    

{.pop.}

template pawnBoard*(color: ColorKind, boards: BitBoards): BitBoard =
    boards[color][PieceKind.Pawn] 

template fullPieceBoard*(color: HelperBitBoardTypes, boards: BitBoards, helpers: HelperBitBoards): BitBoard =
    helpers[color]

proc moveVectorToBitBoard*(x: MoveVector, boards: BitBoards): BitBoard = 
    ## This applies a move vector to a bitboard and returns a copy of the new bitboard
    let
        smv = x.oldPos
        emv = x.newPos
        color = x.piece.color
        kind = x.piece.kind

    #get the current position of the piece in question
    #XOR that with the current board state to get just that piece's position
    #Shift piece to new position:
    #   Remember to verify if we're using shl/shr, depending on whether the piece is going up or down
    #send back new board to be verified
    

    var board = boards[color][kind]
    let currentPiece = BitBoard(0x1'u64 shl 
    var newBoard = BitBoard((0x1000'u64 shl ((RANKS[emv.rank] - RANKS[smv.rank]) * 8'u64)) shl (emv.file - smv.file))
    echo "after testing"
    echo newBoard
    return newBoard
    

proc isValidMove*(movingTo: MoveVector, boardState: BitBoards, helpers: HelperBitBoards): bool = 
    case movingTo.piece.kind:
        of PieceKind.Pawn:
            var validPawnMoves = pawnBoard(movingTo.piece.color, boardState) #Get the pawn board for our color
            var validTwoPushPawnMoves = pawnBoard(movingTo.piece.color, boardState) #Get the pawn board for our color
            var startingPawns: BitBoard
            if movingTo.piece.color == ColorKind.White:
                validPawnMoves = BitBoard(validPawnMoves shl 8) #Shift right to get all available white pawn moves

                #Calculate starting pawn positions
                startingPawns = pawnBoard(movingTo.piece.color, boardState) and BitBoard(bottomRow shr 48)
                
                validTwoPushPawnMoves = BitBoard((validTwoPushPawnMoves and startingPawns) shl 16) #Valid which starting pawns can move further
            else:
                validPawnMoves = BitBoard(validPawnMoves shr 8) #Shift left to get all available pawn moves
                startingPawns = pawnBoard(movingTo.piece.color, boardState) and BitBoard(topRow shl 48)

                validTwoPushPawnMoves = BitBoard((validTwoPushPawnMoves and startingPawns) shr 16) #Valid at the start

            #Check if our square is occupied by ANDing our valid pawn moves by unoccupied spaces
            var validUnoccupiedSquares = (validPawnMoves or validTwoPushPawnMoves) and not (fullPieceBoard(HelperBitBoardTypes.white, boardState, helpers) or fullPieceBoard(HelperBitBoardTypes.black, boardState, helpers)) 

            echo (not (fullPieceBoard(HelperBitBoardTypes.white, boardState, helpers) or fullPieceBoard(HelperBitBoardTypes.black, boardState, helpers)))

            var movedPiece = moveVectorToBitBoard(movingTo, boardState)
            echo "Moved Pieces"
            echo movedPiece

            echo "Is moved Piece in valid area"
        else:
            discard


