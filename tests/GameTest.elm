module GameTest exposing (suite)

import Board
import Expect exposing (Expectation)
import Game exposing (..)
import Player exposing (..)
import Test exposing (..)


suite : Test
suite =
    describe "About game"
        [ test "sets the players" <|
            \_ ->
                let
                    ( gameInit, _ ) =
                        Game.init ()

                    humanVShuman =
                        Game.setMode Human Human gameInit
                in
                Expect.equal
                    { board = [ "", "", "", "", "", "", "", "", "" ]
                    , currentPlayer = { mark = "O", typePlayer = Just Human }
                    , opponent = { mark = "X", typePlayer = Just Human }
                    , positionStatus = Nothing
                    , state = NewGame
                    }
                    humanVShuman
        , test "make a move" <|
            \_ ->
                let
                    ( gameInit, _ ) =
                        Game.init ()

                    game =
                        Game.setMode Human Human gameInit
                            |> Game.nextMove 3
                in
                Expect.equal
                    { board = [ "", "", "", "O", "", "", "", "", "" ]
                    , currentPlayer = { mark = "X", typePlayer = Just Human }
                    , opponent = { mark = "O", typePlayer = Just Human }
                    , positionStatus = Just Valid
                    , state = InProgress
                    }
                    game
        , test "cant make a move if already taken" <|
            \_ ->
                let
                    game =
                        { board = [ "X", "X", "O", "X", "", "", "X", "O", "" ]
                        , currentPlayer = { mark = "O", typePlayer = Just Human }
                        , opponent = { mark = "X", typePlayer = Just Human }
                        , positionStatus = Just Valid
                        , state = InProgress
                        }
                            |> Game.nextMove 3
                in
                Expect.equal
                    { board = [ "X", "X", "O", "X", "", "", "X", "O", "" ]
                    , currentPlayer = { mark = "O", typePlayer = Just Human }
                    , opponent = { mark = "X", typePlayer = Just Human }
                    , positionStatus = Just PositionTaken
                    , state = InProgress
                    }
                    game
        , test "game won by player X" <|
            \_ ->
                let
                    gameWonByX =
                        { board = [ "X", "X", "O", "X", "", "", "", "O", "" ]
                        , currentPlayer = { mark = "X", typePlayer = Just Human }
                        , opponent = { mark = "O", typePlayer = Just Human }
                        , positionStatus = Just PositionTaken
                        , state = InProgress
                        }
                            |> Game.nextMove 6
                in
                Expect.equal
                    { board = [ "X", "X", "O", "X", "", "", "X", "O", "" ]
                    , currentPlayer = { mark = "O", typePlayer = Just Human }
                    , positionStatus = Just Valid
                    , opponent = { mark = "X", typePlayer = Just Human }
                    , state = Won { mark = "X", typePlayer = Just Human }
                    }
                    gameWonByX
        , test "game won by player O" <|
            \_ ->
                let
                    gameWonByO =
                        { board = [ "X", "X", "", "X", "O", "", "O", "O", "X" ]
                        , currentPlayer = { mark = "O", typePlayer = Just Human }
                        , opponent = { mark = "X", typePlayer = Just Human }
                        , positionStatus = Just Valid
                        , state = InProgress
                        }
                            |> Game.nextMove 2
                in
                Expect.equal
                    { board = [ "X", "X", "O", "X", "O", "", "O", "O", "X" ]
                    , currentPlayer = { mark = "X", typePlayer = Just Human }
                    , positionStatus = Just Valid
                    , opponent = { mark = "O", typePlayer = Just Human }
                    , state = Won { mark = "O", typePlayer = Just Human }
                    }
                    gameWonByO
        , test "game drawn" <|
            \_ ->
                let
                    gameDrawn =
                        { board = [ "O", "X", "O", "O", "X", "O", "X", "O", "" ]
                        , currentPlayer = { mark = "X", typePlayer = Just Human }
                        , opponent = { mark = "O", typePlayer = Just Human }
                        , positionStatus = Just Valid
                        , state = InProgress
                        }
                            |> Game.nextMove 8
                in
                Expect.equal
                    { board = [ "O", "X", "O", "O", "X", "O", "X", "O", "X" ]
                    , currentPlayer = { mark = "O", typePlayer = Just Human }
                    , positionStatus = Just Valid
                    , opponent = { mark = "X", typePlayer = Just Human }
                    , state = Draw
                    }
                    gameDrawn
        ]
