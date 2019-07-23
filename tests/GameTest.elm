module GameTest exposing (suite)

import Board
import Dict
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
                            { board =
                                [ ( 0, Empty ), ( 1, Empty ), ( 2, Empty ), ( 3, Empty ), ( 4, Empty ), ( 5, Empty ), ( 6, Empty ), ( 7, Empty ), ( 8, Empty ) ]
                                    |> Dict.fromList
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
                            { board =
                                [ ( 0, Empty ), ( 1, Empty ), ( 2, Empty ), ( 3, Empty ), ( 4, Empty ), ( 5, Empty ), ( 6, Empty ), ( 7, Empty ), ( 8, Empty ) ]
                                    |> Dict.fromList
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
                            { board =
                                [ ( 0, Empty ), ( 1, Empty ), ( 2, Empty ), ( 3, Empty ), ( 4, Empty ), ( 5, Empty ), ( 6, Empty ), ( 7, Empty ), ( 8, Empty ) ]
                                    |> Dict.fromList
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
                            { board =
                                [ ( 0, Empty ), ( 1, Empty ), ( 2, Empty ), ( 3, Empty ), ( 4, Empty ), ( 5, Empty ), ( 6, Empty ), ( 7, Empty ), ( 8, Empty ) ]
                                    |> Dict.fromList
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
                            { board =
                                [ ( 0, Empty ), ( 1, Empty ), ( 2, Empty ), ( 3, O ), ( 4, Empty ), ( 5, Empty ), ( 6, Empty ), ( 7, Empty ), ( 8, Empty ) ]
                                    |> Dict.fromList
                            , currentPlayer = { mark = X, typePlayer = Just Human }
                            , opponent = { mark = O, typePlayer = Just Human }
                            , positionStatus = Just Valid
                            , state = InProgress
                            }
            , test "Do not register the mark in the board if the position is already taken and update the positionStatus to PositionTaken" <|
                \_ ->
                    { board =
                        [ ( 0, X ), ( 1, X ), ( 2, O ), ( 3, X ), ( 4, Empty ), ( 5, Empty ), ( 6, X ), ( 7, O ), ( 8, Empty ) ]
                            |> Dict.fromList
                    , currentPlayer = { mark = O, typePlayer = Just Human }
                    , opponent = { mark = X, typePlayer = Just Human }
                    , positionStatus = Just Valid
                    , state = InProgress
                    }
                        |> Game.update (MakeMove 3)
                        |> Tuple.first
                        |> Expect.equal
                            { board =
                                [ ( 0, X ), ( 1, X ), ( 2, O ), ( 3, X ), ( 4, Empty ), ( 5, Empty ), ( 6, X ), ( 7, O ), ( 8, Empty ) ]
                                    |> Dict.fromList
                            , currentPlayer = { mark = O, typePlayer = Just Human }
                            , opponent = { mark = X, typePlayer = Just Human }
                            , positionStatus = Just PositionTaken
                            , state = InProgress
                            }
            , test "Game won by player X" <|
                \_ ->
                    { board =
                        [ ( 0, X ), ( 1, X ), ( 2, O ), ( 3, X ), ( 4, Empty ), ( 5, Empty ), ( 6, Empty ), ( 7, O ), ( 8, Empty ) ]
                            |> Dict.fromList
                    , currentPlayer = { mark = X, typePlayer = Just Human }
                    , opponent = { mark = O, typePlayer = Just Human }
                    , positionStatus = Just PositionTaken
                    , state = InProgress
                    }
                        |> Game.update (MakeMove 6)
                        |> Tuple.first
                        |> Expect.equal
                            { board =
                                [ ( 0, X ), ( 1, X ), ( 2, O ), ( 3, X ), ( 4, Empty ), ( 5, Empty ), ( 6, X ), ( 7, O ), ( 8, Empty ) ]
                                    |> Dict.fromList
                            , currentPlayer = { mark = O, typePlayer = Just Human }
                            , positionStatus = Just Valid
                            , opponent = { mark = X, typePlayer = Just Human }
                            , state = Won { mark = X, typePlayer = Just Human }
                            }
            , test "Game won by player O" <|
                \_ ->
                    { board =
                        [ ( 0, X ), ( 1, X ), ( 2, Empty ), ( 3, X ), ( 4, O ), ( 5, Empty ), ( 6, O ), ( 7, O ), ( 8, X ) ]
                            |> Dict.fromList
                    , currentPlayer = { mark = O, typePlayer = Just Human }
                    , opponent = { mark = X, typePlayer = Just Human }
                    , positionStatus = Just Valid
                    , state = InProgress
                    }
                        |> Game.update (MakeMove 2)
                        |> Tuple.first
                        |> Expect.equal
                            { board =
                                [ ( 0, X ), ( 1, X ), ( 2, O ), ( 3, X ), ( 4, O ), ( 5, Empty ), ( 6, O ), ( 7, O ), ( 8, X ) ]
                                    |> Dict.fromList
                            , currentPlayer = { mark = X, typePlayer = Just Human }
                            , positionStatus = Just Valid
                            , opponent = { mark = O, typePlayer = Just Human }
                            , state = Won { mark = O, typePlayer = Just Human }
                            }
            , test "Game drawn" <|
                \_ ->
                    { board =
                        [ ( 0, O ), ( 1, X ), ( 2, O ), ( 3, O ), ( 4, X ), ( 5, O ), ( 6, X ), ( 7, O ), ( 8, Empty ) ]
                            |> Dict.fromList
                    , currentPlayer = { mark = X, typePlayer = Just Human }
                    , opponent = { mark = O, typePlayer = Just Human }
                    , positionStatus = Just Valid
                    , state = InProgress
                    }
                        |> Game.update (MakeMove 8)
                        |> Tuple.first
                        |> Expect.equal
                            { board =
                                [ ( 0, O ), ( 1, X ), ( 2, O ), ( 3, O ), ( 4, X ), ( 5, O ), ( 6, X ), ( 7, O ), ( 8, X ) ]
                                    |> Dict.fromList
                            , currentPlayer = { mark = O, typePlayer = Just Human }
                            , positionStatus = Just Valid
                            , opponent = { mark = X, typePlayer = Just Human }
                            , state = Draw
                            }
            ]
        , describe "About minimax"
            [ test "Super computer chooses position to win the game" <|
                \_ ->
                    { board =
                        [ ( 0, X ), ( 1, O ), ( 2, X ), ( 3, O ), ( 4, Empty ), ( 5, X ), ( 6, X ), ( 7, Empty ), ( 8, O ) ]
                            |> Dict.fromList
                    , currentPlayer = { mark = X, typePlayer = Just Super }
                    , opponent = { mark = O, typePlayer = Just Human }
                    , positionStatus = Just Valid
                    , state = InProgress
                    }
                        |> Game.update SuperMove
                        |> Tuple.first
                        |> Expect.equal
                            { board =
                                [ ( 0, X ), ( 1, O ), ( 2, X ), ( 3, O ), ( 4, X ), ( 5, X ), ( 6, X ), ( 7, Empty ), ( 8, O ) ]
                                    |> Dict.fromList
                            , currentPlayer = { mark = O, typePlayer = Just Human }
                            , opponent = { mark = X, typePlayer = Just Super }
                            , positionStatus = Just Valid
                            , state = Won { mark = X, typePlayer = Just Super }
                            }
            , test "Super computer wins the game after two moves" <|
                \_ ->
                    { board =
                        [ ( 0, X ), ( 1, Empty ), ( 2, Empty ), ( 3, O ), ( 4, X ), ( 5, Empty ), ( 6, O ), ( 7, Empty ), ( 8, Empty ) ]
                            |> Dict.fromList
                    , currentPlayer = { mark = X, typePlayer = Just Super }
                    , opponent = { mark = O, typePlayer = Just Human }
                    , positionStatus = Just Valid
                    , state = InProgress
                    }
                        |> Game.update SuperMove
                        |> Tuple.first
                        |> Expect.equal
                            { board =
                                [ ( 0, X ), ( 1, Empty ), ( 2, Empty ), ( 3, O ), ( 4, X ), ( 5, Empty ), ( 6, O ), ( 7, Empty ), ( 8, X ) ]
                                    |> Dict.fromList
                            , currentPlayer = { mark = O, typePlayer = Just Human }
                            , opponent = { mark = X, typePlayer = Just Super }
                            , positionStatus = Just Valid
                            , state = Won { mark = X, typePlayer = Just Super }
                            }
            , test "Super Computer avoids the opponent to win the game" <|
                \_ ->
                    { board =
                        [ ( 0, X ), ( 1, O ), ( 2, X ), ( 3, O ), ( 4, Empty ), ( 5, X ), ( 6, X ), ( 7, Empty ), ( 8, O ) ]
                            |> Dict.fromList
                    , currentPlayer = { mark = O, typePlayer = Just Super }
                    , opponent = { mark = X, typePlayer = Just Human }
                    , positionStatus = Just Valid
                    , state = InProgress
                    }
                        |> Game.update SuperMove
                        |> Tuple.first
                        |> Expect.equal
                            { board =
                                [ ( 0, X ), ( 1, O ), ( 2, X ), ( 3, O ), ( 4, O ), ( 5, X ), ( 6, X ), ( 7, Empty ), ( 8, O ) ]
                                    |> Dict.fromList
                            , currentPlayer = { mark = X, typePlayer = Just Human }
                            , opponent = { mark = O, typePlayer = Just Super }
                            , positionStatus = Just Valid
                            , state = InProgress
                            }
            , test "Super Computer chooses position to win over avoiding opponent to win" <|
                \_ ->
                    { board =
                        [ ( 0, X ), ( 1, O ), ( 2, X ), ( 3, Empty ), ( 4, O ), ( 5, X ), ( 6, X ), ( 7, Empty ), ( 8, Empty ) ]
                            |> Dict.fromList
                    , currentPlayer = { mark = O, typePlayer = Just Super }
                    , opponent = { mark = X, typePlayer = Just Human }
                    , positionStatus = Just Valid
                    , state = InProgress
                    }
                        |> Game.update SuperMove
                        |> Tuple.first
                        |> Expect.equal
                            { board =
                                [ ( 0, X ), ( 1, O ), ( 2, X ), ( 3, Empty ), ( 4, O ), ( 5, X ), ( 6, X ), ( 7, O ), ( 8, Empty ) ]
                                    |> Dict.fromList
                            , currentPlayer = { mark = X, typePlayer = Just Human }
                            , opponent = { mark = O, typePlayer = Just Super }
                            , positionStatus = Just Valid
                            , state = Won { mark = O, typePlayer = Just Super }
                            }
            ]
        ]
