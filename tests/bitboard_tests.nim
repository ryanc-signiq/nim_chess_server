
when isMainModule:
    import unittest, strutils, json
    import nimchesspkg/[types, board]
    suite "test bitboard operations on boards":

        setup:
            echo "Setting up board state"
            var 
                boards: BitBoards
                helpers: HelperBitBoards

            initBoards(boards, helpers)

        teardown:
            echo "Job Done!"

        test "check pawns are created":
            let blackPawnBoard = BitBoard(0x00FF000000000000'u64)
            let whitePawnBoard = BitBoard(0x000000000000FF00'u64)
            check(boards[ColorKind.White][PieceKind.Pawn] == whitePawnBoard)
            check(boards[ColorKind.Black][PieceKind.Pawn] == blackPawnBoard)

        test "check bishop boards are created":
            let blackBishopBoard = BitBoard(0x2400000000000000'u64)
            let whiteBishopBoard = BitBoard(0x0000000000000024'u64)
            check(boards[ColorKind.White][PieceKind.Bishop] == whiteBishopBoard)
            check(boards[ColorKind.Black][PieceKind.Bishop] == blackBishopBoard)

        test "check rook boards are created":
            let blackRookBoard = BitBoard(0x7100000000000000'u64)
            let whiteRookBoard = BitBoard(0x0000000000000071'u64)
            check(boards[ColorKind.White][PieceKind.Rook] == whiteRookBoard)
            check(boards[ColorKind.Black][PieceKind.Rook] == blackRookBoard)

        test "check knight boards are created":
            let blackKnightBoard = BitBoard(0x4200000000000000'u64)
            let whiteKnightBoard = BitBoard(0x0000000000000042'u64)
            check(boards[ColorKind.White][PieceKind.Knight] == whiteKnightBoard)
            check(boards[ColorKind.Black][PieceKind.Knight] == blackKnightBoard)

        test "check queen boards are created":
            let blackQueenBoard = BitBoard(0x1000000000000000'u64)
            let whiteQueenBoard = BitBoard(0x0000000000000010'u64)
            check(boards[ColorKind.White][PieceKind.Queen] == whiteQueenBoard)
            check(boards[ColorKind.Black][PieceKind.Queen] == blackQueenBoard)

        test "check king boards are created":
            let blackKingBoard = BitBoard(0x0800000000000000'u64)
            let whiteKingBoard = BitBoard(0x0000000000000008'u64)
            check(boards[ColorKind.White][PieceKind.King] == whiteKingBoard)
            check(boards[ColorKind.Black][PieceKind.King] == blackKingBoard)

        test "check helper boards are created":
            let allBlackBoard = Bitboard(0xFFFF000000000000'u64)
            let allWhiteBoard = BitBoard(0x000000000000FFFF'u64)
            let allBoard = BitBoard(0xFFFF00000000FFFF'u64)
            check(helpers[HelperBitBoardTypes.black] == allBlackBoard)
            check(helpers[HelperBitBoardTypes.white] == allWhiteBoard)
            check(helpers[HelperBitBoardTypes.all] == allBoard)

        test "check vectors can be applied to BitBoards":
            let moveData = %*
                {
                    "smv": "b3",
                    "emv": "c3",
                    "color": "black",
                    "piece": "pawn",
                }
            let expectedBlackBoard = BitBoard(0xDFFF200000000000'u64)
            let movingTo = initMoveVector(moveData)
            let newBoard = moveVectorToBitBoard(movingTo, boards)

        test "check white pawn moves":
            let moveData = %*
                {
                    "smv": "h3",
                    "emv": "f3",
                    "color": "white",
                    "piece": "pawn",
                }
            let testPawnBoardMove = initMoveVector(moveData)
            let isVal = isValidMove(testPawnBoardMove, boards, helpers)
            echo isVal

        echo "Tests all done!"

