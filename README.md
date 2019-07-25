# Tic Tac Toe in Elm

Tic tac toe is a game for two players who take turns marking the positions in a 3×3 board.

![Jul-24-2019 15-47-40](https://user-images.githubusercontent.com/52838606/61803631-7073af80-ae2a-11e9-8835-9dd28817ff55.gif)

## Objectives

The player who succeeds in placing three of their marks in a horizontal, vertical, or diagonal row wins the game.

## Options

The game allows the player to choose between different modes to play:

- human player vs. human player
- human player vs. random computer
- human player vs. super computer (unbeatable)



## Tech requirements

Having elm 0.19 installed

To check if you already have it installed:

```
elm --version
```
Make sure you have the 0.19 version installed, otherwise upgrade it. 



If it isn't the case, Install it using npm:

```
npm install -g elm
```



## Play

In order to Run the game you need to clone the this github directory to your laptop.

```
git clone git@github.com:BlancaMartin/tres-en-raya.git
```

Open the directory

```
cd tres-en-raya
```

Install the dependencies

```
npm install
```

Build the game

```
npm run build
```

Run the game

```
cd public
```

```
open index.html
```

### And have fun playing!



## Run the unit tests

Open the directory

```
cd tres-en-raya
```

Run the tests

```
npm run test
```



## Run the integration tests

Open the directory

```
cd tres-en-raya
```

Start the server and build the dev environment

```
npm run dev
```

Open cypress (the integration tests app)

```
npm run cypress:open
```

Run the integration tests

In the cypress app, click `Run all specs` on the top right corner


## Technical decisions

### Dictionary type for board

```
type alias Board =
    Dict Int Mark
```

The type I am using to represent a board is a dictionary. The reason why I changed from using a list to using a dictionary is to simplify the way a mark was being registered, because I can update the items in it without having to use external libraries.

It also make it easier to get the positions, because it has a function to get all the keys (that represent the positions of the board) and another one to get items for with a given index, used to know if a position is available or marked.

Having a board of a Dictionary type made it easy to highlight the winning line when a game was won by a player. The positions and marks are linked in pairs and when I found the matching line, I could extract its positions to highlight them using CSS styles.



### Testing random move

Random genertor won't just return a random number, it will create a side effect that Elm can only solve if use it in a Command.
Commands are tested using integration tests.

As referenced in the last paragraph of the official [documentation](https://github.com/elm-explorations/test/tree/1.2.2), there isn't an integration tool in the Elm ecosystem, so I have used cypress to test it.


### Super computer not as a cmd

When playing computer (hard) mode, the human's marker won't appear in the board until the the computer has placed its mark.

This is because the computer has to calculate the best position before updating the board.
I researched about updating the board before the computer move, and I found that can be done by turning the computer move into a Command.
But it is not recommended as it can lead to bugs.

Therefore, I have decided to not implement it.

### Minimax code in Game

When trying to structure my code, I have found that the Elm approach for structuring is very different to other languages.
After watching the [Life of a file](https://youtu.be/XpDsk374LDE), I have realised that the modules are separated by data structures and that a it is normal for a file to have 600 lines

I have the code of the minimax algorithm in my game module because it uses the game data structure. If I wanted to separate it, it would cause an error called cycle break.
Both files would need each other to compile, so Elm can't compile them.


## Improvements

Research more about the last two technical decisions and improve the code according to the findings.

