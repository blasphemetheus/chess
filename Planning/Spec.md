# The Specifications for Chess
The version of Chess I will be making.

Overview: Chess is a board game for 2 players.

The Game Board is a 8 by 8 grid of square tiles where pieces can reside. The size of the game board should be flexible to simplify the game for Extensions, minimum size is 3x3, max is still 8x8 but 3x8 and 8x3 and 4x4 are valid board configurations. 2x2 is not. 3x9 is not. 0x8 is not. -1x8 is not. etc

Players can move pieces around these tiles, but only one piece can reside on a tile at one time. We use index for natural numbers in [0,8) {0, 1, 2, 3, 4, 5, 6, 7}. the index for the other dimension could be in lower case numerals (i.e. i, ii, iii, iv, v, vi, vii or {a, b, c, d, e, f, g, h} as is more common in the chess universe.

There will be a print option available for each coordinate which will put it in the typical chess terms, ie d4, h8 etc. I want to be able to turn the board though, and still have the internal system be comprehensible, so it might be a good idea to use something that isn't a literal translation of the Chess world's norms internally.

The origin of the board is the bottom left corner. Bottom-most border is the x-axis. Left-most border is the y-axis.

Each tile is a square with 4 sides. The tile may be a border square, a corner square, or an interior square.

There are several possible pieces, and I wish to introduce more possible pieces than the norm in the new game plus functionality (a backwards-attacking pawn that can jump forward two always if uninterupted for example -> joker, each player gets one can replace a pawn during their turn). The starting set is as normal. 8 Pawns, 2 Knights, 2 Bishops, 2 Rooks, 1 Queen, 1 King. A full set for each side arranged in the typical starting position for a game of chess.

The type of piece determines the possible moves the player may take with that piece, as does the position of the piece and the position of the other pieces on the board, and the geography of the board (for example, edge pieces etc).

The pieces are place on the board with a certain orientation. Which is only really important for pawns. But this orientation is recorded for now.

Outside of the board, the player has their own information recorded in memory. Things like extra rules or pieces can be recorded here. Extra memory. Settings also, global.

# Goal of game
The goal of a game of chess is to end the game, preferably in a win or a draw for the player in question, but a loss is acceptable as well. A win is much preferred, and a draw is preferred.

The two colors are blue and orange. Orange goes first. 

# Starting the game
The board is initially empty. Then the pieces are placed on the board. This process typically happens in the same way but can happen differently depending on extra rules and player settings. The typical way of putting pieces on the board is the normal chess starting position, with 8 pawns of the starting color (orange) on the bottom 2nd row facing forward, with two rooks on the corners, two knights on their interior, and two bishops on their interior symmetrically and then one Queen on the right interior and one King on the left interior of the bottom row. This configuration is duplicated symmetrically on the other side of the board with the opposite color, except the queens are across from each other.

Starting with the orange color, the player makes a move. They can move one of their pieces in a legal move. All of the legal moves are highlighted by the engine before the player chooses one of them by clicking and dragging or clicking on a piece and clicking on a location

A turn is two moves, one of the starting player and one of the responding player. At the beginning of a turn, the starting player looks at their board, where the possible moves are displayed visually or via a list. They choose an action. Then it becomes the following players action, where they look at a similar array of possible moves and select one. There is a timer going on in the background showing how much time has elapsed and how much time each side has. There is a ten minute timer with the default setting being increments of 0 seconds added with each move. A turn ends when both players have completed an action or the game has ended.

# Ending a Game:
 A game can end via checkmate, draw (via 3peat of a board state), draw by loss of all pieces that could checkmate by both sides, by timeout (where the player whose time has expired loses, or draws out if the opponent has no pawns left).

### INITIAL GOAL OF PROJECT

- player interface which the external players use to program with. The pi must spell out all phases of Chess.

~ how to build the board, placing tiles on the board.
~ how to place initial pieces on the tiles.
~ how to take turns - ie the info a player 
component needs to compute a turn and the info it uses to request an action
~ how/whether to receive info about the end of a game

Additional concepts
- implement at least one player to validate the interface
- referee must supervise a game of players - it may assume nothing about players but the existing interface, all interactions between ref and player components go through this interface
- software framework needs components that represent the physical game pieces:
~ tiles and their internal graph
~ colored tokens, which belong to a specific player
~ boards with the desired number of separate squares
  Together with the player interface these pieces make up the common ontology that players and refs use to communicate
- For dealing with rounds of games, we need to build a tournament manager that runs rounds of games, The creator of the administrator must know the interface of referees and players: its contact with players should be limited to signing them up and connecting them to a referee for a game.

- the human operators of the refs and players may wish to observe Chess games. To implement such viewings, we may need observer components for the players, the refs, or even the admins.

Building it
- first phase -> complete prototype in elixir to demo folks, impress them
- second phase -> break up this monolithic prototype so we can connect the administrator to remote players. We can then demonstrate this as an alpha release.

first phase -> build the components in this order
- basic game pieces, tiles, colored tokens, because the player and ref must use the exact same representation
- the game board
- the player interface
- the ref and the player
- a tournament manager

Once interface is there, could be divided with separate teams working on different parts (with communication layer)

Second phase -> remote proxy pattern to go from the monolithic prototype system to the distributed version. Requiring creation of:
- a remote proxy player
- a remote proxy server
- a communication layer (TCP, could do webhooks? or whatever networking solution elixir docs suggest)
