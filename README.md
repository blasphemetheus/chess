# Chess
Distributed Implementation of Chess.
[![License](https://img.shields.io/badge/license-GPLv3-blue)](https://github.com/blasphemetheus/gchess/blob/main/LICENSE)

Play Chess over the network with custom visuals and a working referee, observers, etc. Start with the basic 'model' stuff, then move on to 'view' then 'controller'. This is kind of Object Oriented style but really I want this to be a software dev level project where I make a version of chess that can be played over a network. Doesn't need to be constrained to an OOD structure. Needs Test driven development ala Fundies 1 and 2 classes at NU Khoury. A functional programming language so some more difficulties, some benefits. Easy test running. Need automated players in some capacity, don't need to be too complicated. Running along the basic ideas of the course I took back in Fall 2019, Software Dev with Mathias  (https://felleisen.org/matthias/4500-f19/assignments.html) though the vesely documentation also would work as an outline (https://vesely.io/teaching/CS4500f19/).

The plan is for anyone who wants to contribute to create their own chess model (in whatever language they prefer) and merge it in here as an alternate model. That model should be able to connect to the tcp_server and communicate via JSON in the common ways. The point is to have a sort of 'json-api' , really an interface, that'll work cross-language. And a tournament could be held with players from different networks using different models and different ways of choosing the next move. At that point it'd be an automated tourney tool to test chess-engines. All that is just a glimmer of ambition in my eye. It's best to focus on the here and now, which is a non-functional chess engine :D.

# License
going with GPL-3.0-or-later
[![License](https://img.shields.io/badge/license-GPLv3-blue)](https://github.com/blasphemetheus/gchess/blob/main/LICENSE)

Though I do want to be able to use this package on my own closed source thing later? So I should switch to MIT if that becomes a reality. I guess if someone contributes then this is something I will address. Shrug.

# Requirements/installation
you must have elixir installed on this machine. I think that's it, other than cloning the repo onto your machine. Try running the tests if you're not sure if it worked. Oh yeah you'll definitely need Git to clone the repo to your machine and keep track of code and whatnot. There could be a future version of this that uses `phoenix` or `scenic` but don't hold your breath. Actually `Scenic` looks cool.

You can also do `iex -S mix` to compile everything and start an interactive session (though this requires knowing about `iex`). You should then be able to run something along the lines of `Main.welcome()` or `Main.startGUI()` to do a simple instance in your Command Line Interface. You can use `mix compile` if that seems more familiar to you. Eventually I'll figure out the ways to just run `./gchess` as an executable but that may require a dependecy or to check for operating systems. Making it a shell script should work just fine actually.

# Testing
Demonstrate how to run test harness.

Explain how to run complete set of internal unit tests And Individual unit tests

Try and do the basic process of good design by starting with unit tests, etc when actually writing the code.

# Test Me
We maintain a script that can run all unit tests. We leverage the `mix test` command to do this.

For convenience you have the option of running on the command line in the `gchess` repository: `sh test_all` this is easier to remember if you don't have exposure to elixir. The only thing the test_all script does is run `mix test --cover`, running the elixir test suite with an option enabled to display coverage. This may become more complicated as testing expands. It probably won't.

As we go, there may be other testing scripts which cover specific testing needs.

The class this project is based off of (memories of) is a software development course that required delivering periodic tests to run off of other classmates' environments. So there is some unnecessary testing complexity, but just ignore it, it won't hurt you.

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