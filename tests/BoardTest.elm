module BoardTest exposing (suite)

import Board
import Expect exposing (Expectation)
import Mark exposing (..)
import Player exposing (..)
import Test exposing (..)


suite : Test
suite =
    describe "About board"
        [ test "get the size of a board" <|
            \_ ->
                let
                    board =
                        Board.init 3
                in
                Expect.equal 3 (Board.size board)
        , test "register a mark in a position in a board" <|
            \_ ->
                let
                    board =
                        Board.init 3

                    player =
                        Player X (Just Human)
                in
                Expect.equal [ Empty, Empty, Empty, Empty, X, Empty, Empty, Empty, Empty ] (Board.register 4 player board)
        , test "board is not full" <|
            \_ ->
                let
                    board =
                        Board.init 3

                    player =
                        Player X (Just Human)

                    markedBoard =
                        Board.register 4 player board
                in
                Expect.equal False (Board.full markedBoard)
        , test "board is full" <|
            \_ ->
                let
                    fullBoard =
                        [ X, O, X, O, X, O, X, O, X ]
                in
                Expect.equal True (Board.full fullBoard)
        , test "gets the available positions of the board" <|
            \_ ->
                let
                    board =
                        [ X, Empty, X, Empty, X, Empty, X, O, X ]
                in
                Expect.equal [ 1, 3, 5 ] (Board.availablePositions board)
        , test "X is a winner" <|
            \_ ->
                let
                    player1 =
                        Player X (Just Human)

                    board =
                        [ X, O, X, Empty, X, Empty, X, O, X ]
                in
                Expect.equal True (Board.isWinner player1 board)
        , test "O is not a winner." <|
            \_ ->
                let
                    player2 =
                        Player O (Just Human)

                    board =
                        [ X, X, X, Empty, O, Empty, X, O, X ]
                in
                Expect.equal False (Board.isWinner player2 board)
        ]
