# Plan for Board Design
Data representation for the tiles and pieces and any extra rules, etc.

Player and Ref components need to agree to interfaces to the board and how to refer to things on the board (positions, team, directions for pawns, threats etc)

Develop data representation for Chess boards with interfaces for players and refs

Describe what the desired methods/functions should compute without predetermining how they should compute it. Data Reps includes data definitions for all related forms of info.

not more than two pages.


So there are `formal_locations`. These represent a place on a board. They are designed to be akin to the chess convention of designating locations as h2 or a7 or the like. The point is for convenience. They go file then rank (column then row).

there are also `dumb_locations`. These are how the locations are stored. they go row then column and are designed for easy line by line representation of a chessboard-like 2d list of locations.

There is also a system called FEN which is sort of a compressed shorthand for denoting a chess position. We should include an input and output function to support FEN.

Our board is made up of a 2d list of lists. We'll call the 2d list `board_locations`. For our purposes this will be a 8by8 2d list for chess.

Tiles aren't actually important to our representation right now so I'm just going to ignore them for now. This could be and will be important for alternate game modes or for rankupzones and whatnot.

We need to be able to represent tiles in the future, so we will include another object called the `tile_spec` to deal with that reality when it comes. For now it is useless and are going to leave it as an empty map.

Next we need some representation of players.

The `referee` and `tournament_organizer` will refer to players by different things. A referee is only aware of the player color. The ref will always respond to any input with well-formed input. That input will include a player-color to indicate which player is making the move.

The `tournament organizer` will refer to the player by the pid. The TO will assign a pid to the player. A player can establish connection with the TO and request a certain tag as well, but the TO assigns the pid.

There can be many players. Many many players. These players can have many strategies, be it intaking human moves in real time, with a timer clock, or choosing from a list of possible moves randomly, or choosing from a list of possible moves by weighting those moves and selecting them according to some sort of formula.

I will create a random move strategy that will be used by artificial players by default then I will implement a simple one-mover that always plays the move that will gain the most material in a certain order (no randomness) then one with random-at-equality. Then try and do something cooler later. Nothing too complex.

The point is that the deterministic ones should be predictable, and the random should lose most of the time to every other one, and there should probably be an order that emerges. So I could run test tourneys and predict a winner's type but maybe not the specific winner.

If I can run tourneys that's all i need there.

I mostly want to implement direct connections between players on the same network.

This will use the json intermediary to transmit information about the state of the game.

If a player plays an illegal move (as determined by the game engine) then they lose the game. It triggers a similar action to resigning. If a player wins a game, the loser is eliminated. If a player draws a game neither are eliminated and the next matchup is drawn randomly. Rounds are recorded by the tournament organizer in some fashion. It's easy to draw but if you ever lose you're out. Games continue until down to 1 player. That's the tournament winner. The rest of the players will be ordered by time lasted in tourney. Multiple players can be listed as 27th etc.

If a `player` cheats and the referee doesn't catch it, it is legal. When a new update is made to the ref, all stats are in a new period for the players. Every revision of the referee will potentially represent new rules.

The referee holds the state of the board and determines if an action by one of the players to play the game is legal. 1 ref can handle many games or 1 ref can handle 1 game. It matters less to me right now than most things.

There could be a game manager to start a specific game. Could just go through TO for that, there will be some representation the TO uses for sure. Shrug.

A game ends in four different ways. A move resulting in checkmate, a move resulting in stalemate, a resignation, a timeout (where the player who spent the least time won), and an agreement to draw. There is also room for draw by repitition as well as playing a certain amount of moves after there are no more pawns, and also being sent into an endgame where it is impossible for either side to win through play.



