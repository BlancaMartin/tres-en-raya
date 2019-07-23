module GameTest exposing (suite)

import Board
import Expect exposing (Expectation)
import Game exposing (..)
import Mark exposing (..)
import Player exposing (..)
import Test exposing (..)


suite : Test
suite =
    describe "About game"
        [ describe "About game flow"
            [ test "create a new game" <|
                \_ ->
                    Game.init ()
                        |> Tuple.first
                        |> Expect.equal
                            { board = [ Empty, Empty, Empty, Empty, Empty, Empty, Empty, Empty, Empty ]
                            , currentPlayer = { mark = O, typePlayer = Nothing }
                            , opponent = { mark = X, typePlayer = Nothing }
                            , positionStatus = Nothing
                            , state = NewGame
                            }
            , test "sets the players for human vs human" <|
                \_ ->
                    Game.init ()
                        |> Tuple.first
                        |> Game.update HumanVsHuman
                        |> Tuple.first
                        |> Expect.equal
                            { board = [ Empty, Empty, Empty, Empty, Empty, Empty, Empty, Empty, Empty ]
                            , currentPlayer = { mark = O, typePlayer = Just Human }
                            , opponent = { mark = X, typePlayer = Just Human }
                            , positionStatus = Nothing
                            , state = InProgress
                            }
            , test "sets the players for human vs random" <|
                \_ ->
                    Game.init ()
                        |> Tuple.first
                        |> Game.update HumanVsRandom
                        |> Tuple.first
                        |> Expect.equal
                            { board = [ Empty, Empty, Empty, Empty, Empty, Empty, Empty, Empty, Empty ]
                            , currentPlayer = { mark = O, typePlayer = Just Human }
                            , opponent = { mark = X, typePlayer = Just Random }
                            , positionStatus = Nothing
                            , state = InProgress
                            }
            , test "sets the players for human vs super computer" <|
                \_ ->
                    Game.init ()
                        |> Tuple.first
                        |> Game.update HumanVsSuper
                        |> Tuple.first
                        |> Expect.equal
                            { board = [ Empty, Empty, Empty, Empty, Empty, Empty, Empty, Empty, Empty ]
                            , currentPlayer = { mark = O, typePlayer = Just Human }
                            , opponent = { mark = X, typePlayer = Just Super }
                            , positionStatus = Nothing
                            , state = InProgress
                            }
            , test "Register a mark in the board and update the positionStatus to valid" <|
                \_ ->
                    Game.init ()
                        |> Tuple.first
                        |> Game.update HumanVsHuman
                        |> Tuple.first
                        |> Game.update (MakeMove 3)
                        |> Tuple.first
                        |> Expect.equal
                            { board = [ Empty, Empty, Empty, O, Empty, Empty, Empty, Empty, Empty ]
                            , currentPlayer = { mark = X, typePlayer = Just Human }
                            , opponent = { mark = O, typePlayer = Just Human }
                            , positionStatus = Just Valid
                            , state = InProgress
                            }
            , test "Do not register the mark in the board if the position is already taken and update the positionStatus to PositionTaken" <|
                \_ ->
                    { board = [ X, X, O, X, Empty, Empty, X, O, Empty ]
                    , currentPlayer = { mark = O, typePlayer = Just Human }
                    , opponent = { mark = X, typePlayer = Just Human }
                    , positionStatus = Just Valid
                    , state = InProgress
                    }
                        |> Game.update (MakeMove 3)
                        |> Tuple.first
                        |> Expect.equal
                            { board = [ X, X, O, X, Empty, Empty, X, O, Empty ]
                            , currentPlayer = { mark = O, typePlayer = Just Human }
                            , opponent = { mark = X, typePlayer = Just Human }
                            , positionStatus = Just PositionTaken
                            , state = InProgress
                            }
            , test "Game won by player X" <|
                \_ ->
                    { board = [ X, X, O, X, Empty, Empty, Empty, O, Empty ]
                    , currentPlayer = { mark = X, typePlayer = Just Human }
                    , opponent = { mark = O, typePlayer = Just Human }
                    , positionStatus = Just PositionTaken
                    , state = InProgress
                    }
                        |> Game.update (MakeMove 6)
                        |> Tuple.first
                        |> Expect.equal
                            { board = [ X, X, O, X, Empty, Empty, X, O, Empty ]
                            , currentPlayer = { mark = O, typePlayer = Just Human }
                            , positionStatus = Just Valid
                            , opponent = { mark = X, typePlayer = Just Human }
                            , state = Won { mark = X, typePlayer = Just Human }
                            }
            , test "game won by player O" <|
                \_ ->
                    { board = [ X, X, Empty, X, O, Empty, O, O, X ]
                    , currentPlayer = { mark = O, typePlayer = Just Human }
                    , opponent = { mark = X, typePlayer = Just Human }
                    , positionStatus = Just Valid
                    , state = InProgress
                    }
                        |> Game.update (MakeMove 2)
                        |> Tuple.first
                        |> Expect.equal
                            { board = [ X, X, O, X, O, Empty, O, O, X ]
                            , currentPlayer = { mark = X, typePlayer = Just Human }
                            , positionStatus = Just Valid
                            , opponent = { mark = O, typePlayer = Just Human }
                            , state = Won { mark = O, typePlayer = Just Human }
                            }
            , test "game drawn" <|
                \_ ->
                    { board = [ O, X, O, O, X, O, X, O, Empty ]
                    , currentPlayer = { mark = X, typePlayer = Just Human }
                    , opponent = { mark = O, typePlayer = Just Human }
                    , positionStatus = Just Valid
                    , state = InProgress
                    }
                        |> Game.update (MakeMove 8)
                        |> Tuple.first
                        |> Expect.equal
                            { board = [ O, X, O, O, X, O, X, O, X ]
                            , currentPlayer = { mark = O, typePlayer = Just Human }
                            , positionStatus = Just Valid
                            , opponent = { mark = X, typePlayer = Just Human }
                            , state = Draw
                            }
            ]
        , describe "About minimax"
            [ test "chooses position to win the game" <|
                \_ ->
                    { board = [ X, O, X, O, Empty, X, X, Empty, O ]
                    , currentPlayer = { mark = X, typePlayer = Just Super }
                    , opponent = { mark = O, typePlayer = Just Human }
                    , positionStatus = Just Valid
                    , state = InProgress
                    }
                        |> Game.update SuperMove
                        |> Tuple.first
                        |> Expect.equal
                            { board = [ X, O, X, O, X, X, X, Empty, O ]
                            , currentPlayer = { mark = O, typePlayer = Just Human }
                            , opponent = { mark = X, typePlayer = Just Super }
                            , positionStatus = Just Valid
                            , state = Won { mark = X, typePlayer = Just Super }
                            }
            , test "avoids the opponent to win the game" <|
                \_ ->
                    { board = [ X, O, X, O, Empty, X, X, Empty, O ]
                    , currentPlayer = { mark = O, typePlayer = Just Super }
                    , opponent = { mark = X, typePlayer = Just Human }
                    , positionStatus = Just Valid
                    , state = InProgress
                    }
                        |> Game.update SuperMove
                        |> Tuple.first
                        |> Expect.equal
                            { board = [ X, O, X, O, O, X, X, Empty, O ]
                            , currentPlayer = { mark = X, typePlayer = Just Human }
                            , opponent = { mark = O, typePlayer = Just Super }
                            , positionStatus = Just Valid
                            , state = InProgress
                            }
            , test "chooses position to win over avoiding opponent to win" <|
                \_ ->
                    { board = [ X, O, X, Empty, O, X, X, Empty, Empty ]
                    , currentPlayer = { mark = O, typePlayer = Just Super }
                    , opponent = { mark = X, typePlayer = Just Human }
                    , positionStatus = Just Valid
                    , state = InProgress
                    }
                        |> Game.update SuperMove
                        |> Tuple.first
                        |> Expect.equal
                            { board = [ X, O, X, Empty, O, X, X, O, Empty ]
                            , currentPlayer = { mark = X, typePlayer = Just Human }
                            , opponent = { mark = O, typePlayer = Just Super }
                            , positionStatus = Just Valid
                            , state = Won { mark = O, typePlayer = Just Super }
                            }
            ]
        ]
