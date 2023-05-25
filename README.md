# GChess
Distributed Implementation of Chess.
[![License](https://img.shields.io/badge/license-GPLv3-blue)](https://github.com/blasphemetheus/gchess/blob/main/LICENSE) [![Elixir CI](https://github.com/blasphemetheus/gchess/actions/workflows/elixir.yml/badge.svg)](https://github.com/blasphemetheus/gchess/actions/workflows/elixir.yml)

Play Chess over the network (eventually).

Current development only supports a Command Line Interface (CLI) view. Using that view, a snapshot of the board is displayed on the screen via the shell one used to run the program. Only local play is supported currently, but online is the goal.

This is an elixir umbrella application, with each subcomponent of the application in it's own `apps` folder.

### Useful links:
- [elixir website](https://elixir-lang.org/)
- [erlange site, that which elixir is built on](https://www.erlang.org/)
- [gen_tcp erlang module docs](https://www.erlang.org/doc/man/gen_tcp.html)
- [protohackers, may be useful to improve knowledge of tcp_server codebase](https://protohackers.com/)
- [Nx repo (ML)](https://github.com/elixir-nx/nx/tree/main/nx)
- [Chess Programming Wiki](https://www.chessprogramming.org/Rules_of_Chess)
- [Phoenix Framework site](https://www.phoenixframework.org/)
- [Scenic on Hex](https://hexdocs.pm/scenic/welcome.html)
- [Scenic on GitHub](https://github.com/ScenicFramework/scenic)
- [git_cheat_sheet](link=https://github.com/JinnaBalu/GitCheatSheet/blob/master/use-cases/git-push-with-ssh.md)
- [Software Dev 2019 Fall NU with Mathias](https://felleisen.org/matthias/4500-f19/assignments.html)


## Architecture
There are a number of subcomponents:

- `board_model` -> a model of the board of a game of chase, including the position (placements) as well as information like halfmove_clock and impale_square (en_passant-enabling location), but notably not the history of a game
- `controller` -> mediates between the model and view, and broadly running games. The takeTurns fn does a lot of work here, and the Main module is located here. Which should probably be removed but whatever
- `view` -> a representation of the game, of the model, as presented to the user. Right now only the `CLI` view is present, but there will be a `scenic` view, which will use a dependency to present an application to the user to click on etc, as well as a `phoenix` view, which will allow a user to interact with the program via the browser.
- `tcp_server` -> this is to support tcp connections to enable our online functionality. There will be server and client-specific code here, but right now it's a sort of template/example codebase drawn mostly from the elixir website's echo server tutorial.
The protohackers website might help me make this subcomponent meatier by providing networking problems to create solutions to.
 

 ## End Goals
 The ambition is to play over a network. Also the goal is to implement observers of games and multiple 'levels' of heuristics-based CPU players. A stretch goal is to try out the [Nx](https://github.com/elixir-nx/nx/tree/main/nx) library and surrounding Machine Learning stack to enable this stuff.

 Test-Driven development is an objectively great way to code. This repo has featured more 'write now, debug later' development, which has been made easier with the `dbg()` tools and the REPL that `iex` makes possible. That's not ideal. The most pressing `TODO` is to: 
 - provide better unit testing coverage for the currently present codebase, as it eliminates bugs proactively and gives good feedback when implementing changes. Also helps identify redundancies in the codebase.
 
Followed by
- Make better automated players (using concepts from a half-remembered AI course in python to implement heuristics, search trees, monte carlo trees, alpha beta pruning, etc to provide some level of ai in tournaments that is more interesting than random or deterministic move selection).
- [Heuristics](https://www.quora.com/What-are-some-heuristics-for-quickly-evaluating-chess-positions): Start with making a 
    - `material_value` heuristic
    - `center_of_board` or `control_center` heuristic
    - `difference_in_position` where you ask how is my position different from my opponents position? If not, then is equal
    - `pawn_structure_quality` heuristic (where isolated, chained, passed, backward, double, triple, quadrupled), so each player has a heuristic value calculated, also uses open and half-open files as an input. Determines as an output whether the match is open or closed (pawns blocking in the center)
    - `space_controlled` heuristic (counting up squares controlled by each side, often dictated by the pawn lines)
    - `squares_threatened` alphazero goes by threatening apparently
    - `weak_strong_squares` where a square cannot be defended by a pawn, with a weaker score if that square would become a strong square for the opponent if they were to reach it with a piece
    - `closed_open_agreement_with_pieces` knights like closed, bishops like open
    - `minor_piece_imbalance` so is it bishop vs bishop opposite color or bishop vs knight? and is that good or bad?
    - `development` which is who has more pieces out and on active squares
    - `king_safety` looking for structural weaknesses in the pawns near the king and whether there are a bunch of opponent pieces near the king
    - `initiative` who is able to dictate the pace of the game, who has the opportunity to make more forcing moves access to more crushing tactics etc

- Document the current codebase and the planned features still in development
 

 ## Background
 I am using a functional programming language so some more difficulties, some benefits. Easy test running. It's also immutable, so testing is free from side effects for most subjects (as long as I don't stray too far).
 
 I do need automated players in some capacity, don't need to be too complicated. Running along the basic ideas of the course I took back in [Fall 2019, Software Dev with Mathias](https://felleisen.org/matthias/4500-f19/assignments.html) though the [vesely documentation](https://vesely.io/teaching/CS4500f19/) also would work as an outline .

## Architecture
The controller component runs everything. There is a CLI_Intro section of the controller which (assuming no arguments are passed in initially indicating to do things automatically with defaults) decides on the context (local between humans, computer, online etc) as well as the details of the matchup (tournament, matchup or game).

The Tournament Organizer will communicate between the tcp_server and the model.

There will be client and server difference. As the Client needs to have a model that sends data over the pipe which is turned into a move in a game, there needs to be a common API (in json or in bytecode or binary packets, it doesn't matter too much). Once there is a common language to communicate with, disparate players can play in the same tournament.

So there exists a sort of 'json-api' , really an interface, that'll work cross-language. And a tournament could be held with players from different networks using different models and different ways of choosing the next move. At that point it'd be an automated tourney tool to test chess-engines.

All that is just a glimmer of ambition. It's best to focus on making the chess engine a complete work.

## Contributing
Contributions can be made by:
- creating your own chess model (in whatever language you prefer) to merge in here as an alternate client. The online `tcp_server` stuff should be standardized and an API will be documented for any branches to conform to. I might make one in Golang if I get that far (I like that language but don't know much of it) or Python if I truly wish to get into the AI stuff.Might also change how this interconnection is possible later (as I'm basically just drawing on the software dev class for ideas here, might be impractical).
- [Making PRs](https://docs.github.com/en/desktop/contributing-and-collaborating-using-github-desktop/working-with-your-remote-repository-on-github-or-github-enterprise/creating-an-issue-or-pull-request) to change the existing elixir codebase. This is just [something that's an option with any open source project](https://dev.to/doctolib/make-your-first-pull-request-to-an-open-source-project-1m57).

# License
going with GPL-3.0-or-later
[![License](https://img.shields.io/badge/license-GPLv3-blue)](https://github.com/blasphemetheus/gchess/blob/main/LICENSE)

So you can use it for open source projects with attribution and notification of changes. Or something close to that, it's linked above.

# Requirements/installation
you must have elixir installed on this machine, and git as well. Then you need to clone this github repo into a local directory run `mix deps.get` to build the dependencies. If you're having any elixir or erlang versioning issues, just use your package manager to get `asdf` to manage versions and make sure it's got compatible versions of elixir and erlang on it.

I think that's it. Try running the tests with `mix test` to confirm it's functional.

Eventually, there will be some dependencies, but not for now.

You should run `iex -S mix` to compile everything and start an interactive session (`iex` is a useful Command Line Utility that enables REPL). You should then be able to run:
- `Main.welcome()` to do a simple instance in your Command Line Interface.
- `Main.tournament()`
- `Main.play()` to play a game vs yourself (or a friend on the same system)
- `Main.train()` to play the computer (random moves for now)
- `Main.simulation()` to watch a computer play another computer in a game etc

Eventually I'll figure out the ways to just run `./gchess` as an executable but that may require a dependecy or to check for operating systems.
# Testing
There is a shell script that can run all unit tests. We leverage the `mix test` command to do this.

For convenience you have the option of running on the command line in the `gchess` repository: `sh test_all` this is easier to remember if you don't have exposure to elixir. The only thing the test_all script does is run `mix test --cover`, running the elixir test suite with an option enabled to display coverage. This may become more complicated as testing expands. It probably won't. 

Currently the most-tested component is the board, running in at around 70% coverage. Then the View.CLI at around 30%.

You can test a specific test or describe block by noting the file and path and just naming it. Shell script should support faster arguments soon.

`mix test apps/board_model/test/board.test.exs` to pick a file to test, or even

`mix test apps/board_model/test/board.test.exs:98` to pick a test at a line number.

The class this project is jumping out of is a software development course that required delivering periodic tests to run off of other classmates' environments.

`xtest` is an early version of it. There will be more.

- shell script or a short program in elixir
- document how to run script in README (check)
- Run script every time before a `git push`
- acceptable for test cases to fail, basic output of script is a couple lines of how many test cases ran, how many passed, how many failed, failing tests are fine during work on the project or if interupted, reminder where to resume
- not ok for unit testing to break things, raise uncaught exception etc. if testing fails, script shows output for me to fix problems

# Model
board_model consists of 
- game
- board
- location
- piece
- tiles
- custom errors if those are kept (BoardError, TileError)

these are in the `lib` directory of `app/board_model`

in the `test` directory of `app/board_model` is the unit tests, as well as some integration tests in their own dir

# View

For now a cli_view that allows a player to choose from:
- vs -> a local game you can play over the keyboard with a friend (or yourself)
- online -> 
- cpu -> a local game you can play against the computer. There will be a number of different levels roughly sketched out as:
 0. level 0 is always the first generated move (deterministic)
 1. random from the available moves
 2. random from available moves, the first tier of those are moves that capture
 3. governed by a naive heuristics fn that picks randomly from center pawns in first move then minor pieces for a couple moves and castles then does randomly
 4. will do mainline openings for a couple lines somehow
 5. also naive
 6. not offline anymore, responds to conditions on the board not to a preset plan
 ... etc

 And then play a chess game, displaying an end screen with the winner.

 There will be future support for tournaments a la the Software Dev coursework. The different levels of cpu are not pivotal and may not be implemented at first.

 for now I'll just stick with doctests i think. View and test-oriented programming requires things like mocks and such and i want to get more basic things down first.

# Controller
honestly this doesn't translate 100% into a remote proxy server design, but the controller is the interaction over tcp between the client and server. The TCPServer is the closest thing to controller. The Tournament Organizer (TO) is also similar, which should spawn GameRunners (or similar name). Sort of unclear if game will be a controller or model component. I'm guessing model. But a GameRunner is something that makes a game, tells it to start etc.

The first version of this will include hardcoded references between the view and board. Not really Model View Controller.
Then those references will be stripped out and replaced by interactions over tcp (via json packages communicated via the tcp_server).
After that, this may be made into a sort of remote-proxy model view controller system if I understand how phoenix works at all and implement it using phoenix.

# Components

roughly separated out into apps of an umbrella mix project. So the gchess project has the following components:
- cli_view
- board_model
- tcp_server
- TO (Tournament Organizer) (includes GameRunner and Referee) (sort of like main)

# Architecture of repo (brief description)
Purpose of each folder and file (nav)

README.md - Overview of Project for browsing, enable future maintainers to find way around code base, add unit tests for bugs, fix a bug, add a feature without necessarily understanding everything about this code base.

# Roadmap base
(so new maintainers can figure out how to nav) - Diagrams to explain relations between pieces, interactions etc

# Chess the game 
Available to play at sites like lichess.org or chess.com etc, this is a very popular game. I think it's in the public domain lol, it's a cool one. Not too complicated to make a backend for (~rolleyes~).

# Extensibility -> GeGnome -> Genomerica -> Chromosomio -> Chromosomer -> Charting The Human Genome
I want to be able to made reasonable modifications to the rules for the purposes of a genomics-related game I hope to tie this module into where you can play as someone using software to browse the human genome and as you progress through learning about it, you establish goals and motivations for your research and discoveries that effect the game. It's all revealed later on as a representation of chess though, where you have exactly as many options as there are possible moves in a game of chess, with each possibility. All the usual openings are enforced in the first phase of the game (like a learn how the actual game is to play, before you are shown the chess engine behind it, where you're just learning about genomics for a couple hours. Then you learn about chess because it is fun.) I also want the player to be able to reference the yfull mtdna and y-dna tree and input their own haplogroup info or choose randomly and have this eventually effect the options within the game, but I have no idea on the details of that. It won't be accurate to the world in any way, just thought could be fun.

Moving through the game will be moving through the chromosomes (28 of them) and I want the first playthrough to provide a bunch of knowledge and resources to learn about genomics and the human genome and the different processes happening. Players will also be able to leave feedback at any point in the game (requests for new features or incorrect/out of date science or suggestions for more explanations etc). The point of the game is fun, but the byproduct, the lore of the game is actual science is the intent, or at least popular science summaries of current understandings of how the human genome works. REAL BIG TBD HERE, need Chess to be done first :).

# Cool stuff
- [Nerves embedded/IoT](https://nerves-project.org/)
