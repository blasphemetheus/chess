# Local
interaction diagram resulting from design task

Distributed Implementation of Chess
```
TO          Referee         Player
|           |               |
|           |               |
|           |               |
|           |               |
|           |               |
|           |               |
|           |               |
|           |               |
<--------------------------- player contacts TO with tag
|
TO accepts tag if not already used and sends back an `{:ok, "welcome #{tag}}` or an `{:error, "denied #{tag} for #{reason}}`. Internally they assign a pid and create an entry for a player. When they have enough players they will start a tournament. A tournament matches up pairs of players and makes them play a game of chess. A player may time out, losing or win somehow, passing on to the next round. The rounds are logged, as are the games. Each game logs the inputted moves by the player.
-------------------------------> TO sends player back a response to their request to join
|           |               |
|           |               |
---------------------------> TO sends a player a game to play. They could also assign a game_manager here or the tournament_organizer could act in that capacity. The TO assigns a referee to a game. A referee decides on whethera move is legal or not.
|           |               |
|           |               |
|           |<--------------- the player sends the referee a move
|           |---------------> the ref either accepts or denies the move. on deny, the player loses and is kicked.
|           |               |
|           |               |
|           |-------------->| the ref tells the player whose turn it is that it is their turn, tells them if they have a special turn to make (ie rankup, whether they are in check etc)
|           |               |
...
|           |               |
|           |               |
|           |-------------->| the ref tells the players if the game is over
|           |               |
|           |               |
|<----------| the referee tells the TO how the game went, who won etc, the order of moves and more. The TO then logs that information in like a ubjson format or similar (plaintext for now for easy parsing)
|           |               |
|           |               |




```