
when isMainModule:
    import unittest, strutils
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
            check(boards[ColorKind.white][PieceKind.pawn] == whitePawnBoard)
            check(boards[ColorKind.black][PieceKind.pawn] == blackPawnBoard)

        test "check bishop boards are created":
            let blackBishopBoard = BitBoard(0x2400000000000000'u64)
            let whiteBishopBoard = BitBoard(0x0000000000000024'u64)
            check(boards[ColorKind.white][PieceKind.bishop] == whiteBishopBoard)
            check(boards[ColorKind.black][PieceKind.bishop] == blackBishopBoard)

        test "check rook boards are created":
            let blackRookBoard = BitBoard(0x7100000000000000'u64)
            let whiteRookBoard = BitBoard(0x0000000000000071'u64)
            check(boards[ColorKind.white][PieceKind.rook] == whiteRookBoard)
            check(boards[ColorKind.black][PieceKind.rook] == blackRookBoard)

        test "check knight boards are created":
            let blackKnightBoard = BitBoard(0x4200000000000000'u64)
            let whiteKnightBoard = BitBoard(0x0000000000000042'u64)
            check(boards[ColorKind.white][PieceKind.knight] == whiteKnightBoard)
            check(boards[ColorKind.black][PieceKind.knight] == blackKnightBoard)

        test "check queen boards are created":
            let blackQueenBoard = BitBoard(0x1000000000000000'u64)
            let whiteQueenBoard = BitBoard(0x0000000000000010'u64)
            check(boards[ColorKind.white][PieceKind.queen] == whiteQueenBoard)
            check(boards[ColorKind.black][PieceKind.queen] == blackQueenBoard)

        test "check king boards are created":
            let blackKingBoard = BitBoard(0x0800000000000000'u64)
            let whiteKingBoard = BitBoard(0x0000000000000008'u64)
            check(boards[ColorKind.white][PieceKind.king] == whiteKingBoard)
            check(boards[ColorKind.black][PieceKind.king] == blackKingBoard)

        test "check helper boards are created":
            let allBlackBoard = Bitboard(0xFFFF000000000000'u64)
            let allWhiteBoard = BitBoard(0x000000000000FFFF'u64)
            let allBoard = BitBoard(0xFFFF00000000FFFF'u64)
            check(helpers[HelperBitBoardTypes.black] == allBlackBoard)
            check(helpers[HelperBitBoardTypes.white] == allWhiteBoard)
            check(helpers[HelperBitBoardTypes.all] == allBoard)

        test "check white pawn moves":
            let testPawnBoardFinal = BitBoard(0x000000000020DF00'u64)
            let testPawnMove = BitBoard(0x0000000000200000'u64)
            echo "Showing Pawn Board Final"
            echo testPawnBoardFinal
            echo "Showing Pawn Board current"
            echo boards[ColorKind.white][PieceKind.pawn]
            echo "Test Pawn Move"
            echo testPawnMove
            echo "Moved Now"
            var moved = performMove(boards[ColorKind.white][PieceKind.pawn], testPawnMove)
            echo moved
            check(moved == testPawnBoardFinal)

        echo "Tests all done!"
