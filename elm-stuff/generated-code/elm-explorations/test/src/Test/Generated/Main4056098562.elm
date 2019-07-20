module Test.Generated.Main4056098562 exposing (main)

import GameTest
import PlayerTest
import BoardTest

import Test.Reporter.Reporter exposing (Report(..))
import Console.Text exposing (UseColor(..))
import Test.Runner.Node
import Test

main : Test.Runner.Node.TestProgram
main =
    [     Test.describe "GameTest" [GameTest.suite],     Test.describe "PlayerTest" [PlayerTest.suite],     Test.describe "BoardTest" [BoardTest.suite] ]
        |> Test.concat
        |> Test.Runner.Node.run { runs = Nothing, report = (ConsoleReport UseColor), seed = 45081673056764, processes = 4, paths = ["/Users/miss.merce/Workspace/Elm/tres-en-raya/tests/BoardTest.elm","/Users/miss.merce/Workspace/Elm/tres-en-raya/tests/GameTest.elm","/Users/miss.merce/Workspace/Elm/tres-en-raya/tests/PlayerTest.elm"]}