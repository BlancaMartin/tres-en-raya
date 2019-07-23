module BoardTest exposing (suite)

import Board
import Dict
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

                    boardInit =
                        [ ( 0, Empty ), ( 1, Empty ), ( 2, Empty ), ( 3, Empty ), ( 4, X ), ( 5, Empty ), ( 6, Empty ), ( 7, Empty ), ( 8, Empty ) ]
                            |> Dict.fromList
                in
                Expect.equal boardInit (Board.register 4 player board)
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
                        [ ( 0, X ), ( 1, O ), ( 2, X ), ( 3, O ), ( 4, X ), ( 5, O ), ( 6, X ), ( 7, O ), ( 8, X ) ]
                            |> Dict.fromList
                in
                Expect.equal True (Board.full fullBoard)
        , test "gets the available positions of the board" <|
            \_ ->
                let
                    board =
                        [ ( 0, X ), ( 1, Empty ), ( 2, X ), ( 3, Empty ), ( 4, X ), ( 5, Empty ), ( 6, X ), ( 7, O ), ( 8, X ) ]
                            |> Dict.fromList
                in
                Expect.equal [ 1, 3, 5 ] (Board.availablePositions board)
        , test "gets the winning line positions of the board" <|
            \_ ->
                let
                    winner =
                        Player X (Just Human)

                    board =
                        [ ( 0, X ), ( 1, Empty ), ( 2, X ), ( 3, Empty ), ( 4, X ), ( 5, Empty ), ( 6, X ), ( 7, O ), ( 8, O ) ]
                            |> Dict.fromList
                in
                Expect.equal [ 2, 4, 6 ] (Board.winningLine winner board)
        , test "X is a winner" <|
            \_ ->
                let
                    player1 =
                        Player X (Just Human)

                    board =
                        [ ( 0, X ), ( 1, O ), ( 2, X ), ( 3, Empty ), ( 4, X ), ( 5, Empty ), ( 6, X ), ( 7, O ), ( 8, X ) ]
                            |> Dict.fromList
                in
                Expect.equal True (Board.isWinner player1 board)
        , test "O is not a winner." <|
            \_ ->
                let
                    player2 =
                        Player O (Just Human)

                    board =
                        [ ( 0, X ), ( 1, X ), ( 2, X ), ( 3, Empty ), ( 4, O ), ( 5, Empty ), ( 6, X ), ( 7, O ), ( 8, X ) ]
                            |> Dict.fromList
                in
                Expect.equal False (Board.isWinner player2 board)
        ]
