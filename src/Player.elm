module Player exposing (Player, TypePlayer(..), addType)

import Mark exposing (..)



--TYPES


type TypePlayer
    = Human
    | Random
    | Super


type alias Player =
    { mark : Mark
    , typePlayer : Maybe TypePlayer
    }



--TRANSFORM


addType : TypePlayer -> Player -> Player
addType playerType player =
    case playerType of
        Human ->
            { player | typePlayer = Just Human }

        Random ->
            { player | typePlayer = Just Random }

        Super ->
            { player | typePlayer = Just Super }
