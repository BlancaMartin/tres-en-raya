module PlayerTest exposing (suite)

import Expect exposing (Expectation)
import Player exposing (..)
import Test exposing (..)


suite : Test
suite =
    describe "About player"
        [ test "creates a Human player" <|
            \_ ->
                let
                    player =
                        Player "O" Nothing
                in
                Expect.equal { mark = "O", typePlayer = Just Human } (Player.addType Human player)
        ]
