## Tests on bitfield operations on BoardState and Piece objects


when isMainModule:
    import unittest
    import nimchesspkg/[types, board]
    suite "test bitfield operations on boards":

        setup:
            echo "Setting up board state"
            let testBoard = newBoardState() 

        teardown:
            echo "Job Done!"

        test "piece did move":
            let newTestBoard = newBoardState()
            check(testBoard != newTestBoard)

        test "piece didn't move":
            let newTestBoard = newBoardState()
            check(testBoard == newTestBoard)

        test "piece attacks piece":
            let newTestBoard = newBoardState()
            check(testBoard != newTestBoard)

        test "piece attacked by piece":
            let newTestBoard = newBoardState()
            check(testBoard != newTestBoard)

        echo "Tests all done!"
