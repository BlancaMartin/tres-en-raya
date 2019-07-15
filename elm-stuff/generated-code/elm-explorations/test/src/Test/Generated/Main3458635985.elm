module Test.Generated.Main3458635985 exposing (main)

import BoardTest

import Test.Reporter.Reporter exposing (Report(..))
import Console.Text exposing (UseColor(..))
import Test.Runner.Node
import Test

main : Test.Runner.Node.TestProgram
main =
    [     Test.describe "BoardTest" [BoardTest.suite] ]
        |> Test.concat
        |> Test.Runner.Node.run { runs = Nothing, report = (ConsoleReport UseColor), seed = 262518320804099, processes = 4, paths = ["/Users/miss.merce/Workspace/Elm/tres-en-raya/tests/BoardTest.elm"]}