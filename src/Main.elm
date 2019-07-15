module Main exposing (main)

import Browser
import Game exposing (..)


main : Program () Game Msg
main =
    Browser.document
        { view = Game.view
        , init = Game.init
        , update = Game.update
        , subscriptions = always Sub.none
        }
