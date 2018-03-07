
when isMainModule:
    import unittest
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


        echo "Tests all done!"
