module GameTest exposing (suite)

import Board
import Expect exposing (Expectation)
import Game exposing (..)
import Player exposing (..)
import Test exposing (..)


suite : Test
suite =
    describe "About game"
        [ test "New game" <|
            \_ ->
                Game.init ()
                    |> Tuple.first
                    |> Expect.equal
                        { board = [ "", "", "", "", "", "", "", "", "" ]
                        , currentPlayer = { mark = "O", typePlayer = Nothing }
                        , opponent = { mark = "X", typePlayer = Nothing }
                        , positionStatus = Nothing
                        , state = NewGame
                        }
        , test "sets the players" <|
            \_ ->
                Game.init ()
                    |> Tuple.first
                    |> Game.update HumanVsHuman
                    |> Tuple.first
                    |> Expect.equal
                        { board = [ "", "", "", "", "", "", "", "", "" ]
                        , currentPlayer = { mark = "O", typePlayer = Just Human }
                        , opponent = { mark = "X", typePlayer = Just Human }
                        , positionStatus = Nothing
                        , state = InProgress
                        }
        , test "make a move" <|
            \_ ->
                Game.init ()
                    |> Tuple.first
                    |> Game.update HumanVsHuman
                    |> Tuple.first
                    |> Game.update (MakeMove 3)
                    |> Tuple.first
                    |> Expect.equal
                        { board = [ "", "", "", "O", "", "", "", "", "" ]
                        , currentPlayer = { mark = "X", typePlayer = Just Human }
                        , opponent = { mark = "O", typePlayer = Just Human }
                        , positionStatus = Just Valid
                        , state = InProgress
                        }
        , test "cant make a move if already taken" <|
            \_ ->
                { board = [ "X", "X", "O", "X", "", "", "X", "O", "" ]
                , currentPlayer = { mark = "O", typePlayer = Just Human }
                , opponent = { mark = "X", typePlayer = Just Human }
                , positionStatus = Just Valid
                , state = InProgress
                }
                    |> Game.update (MakeMove 3)
                    |> Tuple.first
                    |> Expect.equal
                        { board = [ "X", "X", "O", "X", "", "", "X", "O", "" ]
                        , currentPlayer = { mark = "O", typePlayer = Just Human }
                        , opponent = { mark = "X", typePlayer = Just Human }
                        , positionStatus = Just PositionTaken
                        , state = InProgress
                        }
        , test "game won by player X" <|
            \_ ->
                { board = [ "X", "X", "O", "X", "", "", "", "O", "" ]
                , currentPlayer = { mark = "X", typePlayer = Just Human }
                , opponent = { mark = "O", typePlayer = Just Human }
                , positionStatus = Just PositionTaken
                , state = InProgress
                }
                    |> Game.update (MakeMove 6)
                    |> Tuple.first
                    |> Expect.equal
                        { board = [ "X", "X", "O", "X", "", "", "X", "O", "" ]
                        , currentPlayer = { mark = "O", typePlayer = Just Human }
                        , positionStatus = Just Valid
                        , opponent = { mark = "X", typePlayer = Just Human }
                        , state = Won { mark = "X", typePlayer = Just Human }
                        }
        , test "game won by player O" <|
            \_ ->
                { board = [ "X", "X", "", "X", "O", "", "O", "O", "X" ]
                , currentPlayer = { mark = "O", typePlayer = Just Human }
                , opponent = { mark = "X", typePlayer = Just Human }
                , positionStatus = Just Valid
                , state = InProgress
                }
                    |> Game.update (MakeMove 2)
                    |> Tuple.first
                    |> Expect.equal
                        { board = [ "X", "X", "O", "X", "O", "", "O", "O", "X" ]
                        , currentPlayer = { mark = "X", typePlayer = Just Human }
                        , positionStatus = Just Valid
                        , opponent = { mark = "O", typePlayer = Just Human }
                        , state = Won { mark = "O", typePlayer = Just Human }
                        }
        , test "game drawn" <|
            \_ ->
                { board = [ "O", "X", "O", "O", "X", "O", "X", "O", "" ]
                , currentPlayer = { mark = "X", typePlayer = Just Human }
                , opponent = { mark = "O", typePlayer = Just Human }
                , positionStatus = Just Valid
                , state = InProgress
                }
                    |> Game.update (MakeMove 8)
                    |> Tuple.first
                    |> Expect.equal
                        { board = [ "O", "X", "O", "O", "X", "O", "X", "O", "X" ]
                        , currentPlayer = { mark = "O", typePlayer = Just Human }
                        , positionStatus = Just Valid
                        , opponent = { mark = "X", typePlayer = Just Human }
                        , state = Draw
                        }
        , test "chooses position to win the game" <|
            \_ ->
                let
                    game =
                        { board = [ "X", "O", "X", "O", "", "X", "X", "", "O" ]
                        , currentPlayer = { mark = "X", typePlayer = Just Super }
                        , opponent = { mark = "O", typePlayer = Just Human }
                        , positionStatus = Just Valid
                        , state = InProgress
                        }
                in
                Expect.equal 4 (Game.getBestPosition game)
        , test "avoids the opponent to win the game" <|
            \_ ->
                let
                    game =
                        { board = [ "X", "O", "X", "O", "", "X", "X", "", "O" ]
                        , currentPlayer = { mark = "O", typePlayer = Just Super }
                        , opponent = { mark = "X", typePlayer = Just Human }
                        , positionStatus = Just Valid
                        , state = InProgress
                        }
                in
                Expect.equal 4 (Game.getBestPosition game)
        , test "chooses position to win over avoiding opponent to win" <|
            \_ ->
                let
                    game =
                        { board = [ "X", "O", "X", "", "O", "X", "X", "", "" ]
                        , currentPlayer = { mark = "O", typePlayer = Just Super }
                        , opponent = { mark = "X", typePlayer = Just Human }
                        , positionStatus = Just Valid
                        , state = InProgress
                        }
                in
                Expect.equal 7 (Game.getBestPosition game)
        ]
