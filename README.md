# Tic Tac Toe in Elm

Tic tac toe is a game for two players who take turns marking the positions in a 3×3 board.

## Objectives

The player who succeeds in placing three of their marks in a horizontal, vertical, or diagonal row wins the game.

## Options

The game allows the player to choose between different modes to play:

- human player vs. human player
- human player vs. random computer
- human player vs. super computer (unbeatable)



## Tech requirements

Having elm installed

To check if you already have it installed:

```
elm --version
```



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

Install the dev dependencies 

```
npm install
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

Install the dev dependencies (step not needed if you have already run it for the unit tests)

```
npm install
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


## Architecture diagram

## Technical decisions

## Improvements


