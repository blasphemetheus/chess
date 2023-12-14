# GChess
Distributed Implementation of Chess.
[![License](https://img.shields.io/badge/license-GPLv3-blue)](https://github.com/blasphemetheus/gchess/blob/main/LICENSE) [![Elixir CI](https://github.com/blasphemetheus/gchess/actions/workflows/elixir.yml/badge.svg)](https://github.com/blasphemetheus/gchess/actions/workflows/elixir.yml)

Play Chess in elixir. Works in a CLI tool, with optional view of C-based GUI (alpine/manjaro supported because dependencies come pre-wrangled) via Scenic. Also in a Phoenix-based web-app coming soon.

A way to learn more about the Elixir ecosystem by making remaking chess and the ur game.

There is a Command Line Interface (CLI) view. Using that view, a snapshot of the board is displayed on the screen via the shell one used to run the program. Only local play is supported currently, but online is the goal.

There is a Scenic View, which requires scenic and it's various dependencies to run. But if you get that all figured out ([this page has some helpful steps](https://medium.com/@giandr/elixir-scenic-snake-game-b8616b1d7ee0#%22Setting%20up%22), or [this page](https://github.com/ScenicFramework/scenic_new#install-prerequisites)).

## Dev Environment
(actually I killed my manjaro setup accidentally and didn't reimage it for a while, so I'm starting again with Alpine on a vm, so if I break things I'm more likely to fix it and move on :) )
I develop on Manjaro linux using sway and in that environment, it's easy to download dependencies (rolling releases, bleeding edge updates, yada yada. It's convenient. You can sue me for being a penguin guy). I got it working on Windows and tried for a while on raspberry pi's debian but it's not simple. The free github workflow for elixir CI testing doesn't support MacOS (under Actions on Github). So when I get that working I'll have a decent excuse not to support Apple products :). Relies on the glfw or glew C libraries which you need to find the right development libraries for that matches your Elixir and Erlang versions. asdf is the best way to manage your elixir and erlang versions. Rule of thumb, if you can get the complicated Scenic example one running, this should run too.

Oh, I used the generative AI tools a bit at first to see if they were helpful. CoPilot mostly just gave me boilerplate to rewrite later so I stopped using that after a week.

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
There are a number of subcomponents in this monolithic library:

- `board_model` -> a model of the board of a game of chase, including the position (placements) as well as information like halfmove_clock and impale_square (en_passant-enabling location), but notably not the history of a game
- `controller` -> mediates between the model and view, and broadly running games. The takeTurns fn does a lot of work here, and the Main module is located here. Which should probably be removed but whatever
- `view` -> a representation of the game, of the model, as presented to the user. Right now the `CLI` view is present, as well as a `sc` view for scenic. This dependency is a GUI that works on the OS level, no browser involved. If you want a browser involved, the `phx` view for phoenix will also be available. I have to tinker around with it (ie learn phoenix) before implementation. It looks really powerful and harbors an opportunity to refactor my extremely bruteforcy sc gui code to represent chess into a more elegant, refined, credo-passing implementation of a clickable chessboard. Draggable this time too hopefully.
- `tcp_server` -> this is to support tcp connections to enable our online functionality. There will be server and client-specific code here, but right now it's a sort of template/example codebase drawn mostly from the elixir website's echo server tutorial. Might also be eaten by phoenix. Shrug. No loss there.
The protohackers website might help me make this subcomponent meatier by providing networking problems to create solutions to.
 
 ## End Goals
 The ambition is to play over a network. Also the goal is to implement observers of games and multiple 'levels' of heuristics-based CPU players. A stretch goal is to try out the [Nx](https://github.com/elixir-nx/nx/tree/main/nx) library and surrounding Machine Learning stack to enable this stuff. This should be possible now, I just need to review old class-work and notes on how to implement adverserial agents and search trees and all that, then transfer it from the abominable hellscape of python to the summery oasis of elixir. :). I'll probably have to rewrite parts of my codebase to support more performant data structures for training of agents. Nx supports Tensors, which is how some popular chess engines do things. I use what I think is called a dataframe right now (2D list) to represent placements of pieces, nested into a board struct that itself nested into a gamerunner struct (to track things like history, game resolution, players, etc).

 Test-Driven development is an objectively great way to code. This repo has featured more 'write now, debug later' development, which has been made easier with the `dbg()` tools and the REPL that `iex` makes possible. That's not ideal. The most pressing `TODO` is to: 
 - provide better unit testing coverage for the currently present codebase, as it eliminates bugs proactively and gives good feedback when implementing changes. Also helps identify redundancies in the codebase. (this has been kicked back, as `write now, debug later` dictates, to indefinite liminal space on the todo hierarchy, to think about what it did).
 - Make better automated players (using concepts from a [half-remembered AI course in python](https://github.com/blasphemetheus/old_ai_python_class) to implement heuristics, search trees, monte carlo trees, alpha beta pruning, etc to provide some level of ai in tournaments that is more interesting than random or deterministic move selection). The goal here is to train agents using reinforcement learning and then unleash them online to be bested by users. Hey lets say there's a bot bounty program where a user gets fake money for defeating the bots in blitz games. Zynga all the way down. Hey lets mint our own fake currency to try and cash in on web3 <no>.
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
 
According to the basic ideas of the course I took back in [Fall 2019, Software Dev with Mathias](https://felleisen.org/matthias/4500-f19/assignments.html) or the [vesely documentation](https://vesely.io/teaching/CS4500f19/), I do need automated players in some capacity, and they don't need to be too complicated.

However, I am unsatisfied by this. I need to be able to play against agents I helped make. For honor or pride or something. Mostly because that's what People keep on assuming I'm working on if I bring this project up.
 
## Architecture
The controller component runs everything. There is a CLI_Intro section of the controller which (assuming no arguments are passed in initially indicating to do things automatically with defaults) decides on the context (local between humans, computer, online etc) as well as the details of the matchup (tournament, matchup or game).

The Tournament Organizer will communicate between the tcp_server and the model.

There will be client and server difference. As the Client needs to have a model that sends data over the pipe which is turned into a move in a game, there needs to be a common API (in json or in bytecode or binary packets, it doesn't matter too much). Once there is a common language to communicate with, disparate players can play in the same tournament.

So there exists a sort of 'json-api' , really an interface, that'll work cross-language. And a tournament could be held with players from different networks using different models and different ways of choosing the next move. At that point it'd be an automated tourney tool to test chess-engines.

All that is just a glimmer of ambition. It's best to focus on making the chess engine a complete work.

## Contributing
Contributions can be made by:
- creating your own chess model (in whatever language you prefer) to merge in here as an alternate client. The online `tcp_server` stuff should be standardized and an API will be documented for any branches to conform to. I might make one in Golang if I get that far (I like that language but haven't made anything of note in it) or Python if I truly wish to get into the AI stuff. {If I go psycho-mode then RUST here we come, becoming a RUSTACEAN, DOGMA!} Might also change how this interconnection is possible later (as I'm basically just drawing on the software dev class for ideas here, might be impractical).
- [Making PRs](https://docs.github.com/en/desktop/contributing-and-collaborating-using-github-desktop/working-with-your-remote-repository-on-github-or-github-enterprise/creating-an-issue-or-pull-request) to change the existing elixir codebase. This is just [something that's an option with any open source project](https://dev.to/doctolib/make-your-first-pull-request-to-an-open-source-project-1m57).

# License
going with GPL-3.0-or-later
[![License](https://img.shields.io/badge/license-GPLv3-blue)](https://github.com/blasphemetheus/gchess/blob/main/LICENSE)

So you can use it for open source projects with attribution and notification of changes. Or something close to that, it's linked above.

# Requirements/installation
you must have elixir installed on this machine, and git as well. Then you need to clone this github repo into a local directory run `mix deps.get` to build the dependencies. If you're having any elixir or erlang versioning issues, just use your package manager to get `asdf` to manage versions and make sure it's got compatible versions of elixir and erlang on it.

I think that's it. Try running the tests with `mix test` to confirm it's functional.

You should run `iex -S mix` to compile everything and start an interactive session (`iex` is a useful Command Line Utility that enables REPL). You should then be able to run:
- `Main.welcome()` to do a simple instance in your Command Line Interface.
- `Main.tournament()`
- `Main.play()` to play a game vs yourself (or a friend on the same system)
- `Main.train()` to play the computer (random moves for now)
- `Main.simulation()` to watch a computer play another computer in a game etc

Eventually I'll figure out the ways to just run `./gchess` as an executable but that may require a dependecy or to check for operating systems. Really, that sort of functionality is well-documented in the introductory pragmattic programming-style books on elixir. There's probably a library that makes it trivial.
 
# Testing
There is a shell script that can run all unit tests. We leverage the `mix test` command to do this.

For convenience you have the option of running on the command line in the `gchess` repository: `sh test_all` this is easier to remember if you don't have exposure to elixir. The only thing the test_all script does is run `mix test --cover`, running the elixir test suite with an option enabled to display coverage. This may become more complicated as testing expands. It probably won't. 

You can test a specific test or describe block by noting the file and path and just naming it. Shell script should support faster arguments soon.

`mix test apps/board_model/test/board.test.exs` to pick a file to test, or even

`mix test apps/board_model/test/board.test.exs:98` to pick a test at a line number.

The class this project is jumping out of is a software development course that required delivering periodic tests to run off of other classmates' environments.

`xtest` is an early version of it. There will be more.

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

 There will be future support for single elimination tournaments. The different levels of cpu are not pivotal and may not be implemented at first.

# Controller
honestly this doesn't translate 100% into a remote proxy server design, but the controller is the interaction over tcp between the client and server. The TCPServer is the closest thing to controller. The Tournament Organizer (TO) is also similar, which should spawn GameRunners (or similar name). Sort of unclear if game will be a controller or model component. I'm guessing model. But a GameRunner is something that makes a game, tells it to start etc.

This is currently a monolithic app with hardcoded references between the view and board. Not really Model View Controller.
These references will be stripped out and replaced by interactions over tcp or websockets (depending on if phoenix or the tcp_server is used). JSON is probably the easiest OTP encoding to use.
 
Phoenix will be how this program runs. I may support a browserless release as well as a browser-based release. The browserless one would use Scenic or the CLI as it's view. The Browser-based one would use the CLI, Scenic or the Browser. Or some combination of that type of thing. Phoenix is good. Scenic is also very cool, but requires more scenic-specific study to make my implementation professional.

# Components
This is a run-of-the-mill elixir monolithic applicaiton, with one mix file.
 There are some subdirectories to know about, that represent components of this system.
- view
- model
- tcp_server
- controller
- sc (scenic view)*
- phx (phoenix view)*
 
*please note that these should be incorporated into the view folder or organized differently. I'm still learning about supervision trees and how best to support a scenic view AS WELL AS a phoenix browser view. I think it'll all eventually run through phoenix, with the sc being it's own supervision tree that can be specified at compile time (if it's known it won't be used) or at run-time (the sc supervisor will be killed, of course, it'll still need scenic to compile properly in this case).
 
# Architecture of repo (brief description)
Purpose of each folder and file (nav)

README.md - Overview of Project for browsing, enable future maintainers to find way around code base, add unit tests for bugs, fix a bug, add a feature without necessarily understanding everything about this code base.

# Roadmap base
(so new maintainers can figure out how to nav) - Diagrams to explain relations between pieces, interactions etc

# Chess the game 
Available to play at sites like lichess.org or chess.com etc, this is a very popular game.
 
### I'd like to support an implementation of Coup (or a coup lookalike depending on the copyright implications there). I'd also love to support implementations of Ur (with live fake-currency gambling as an extra mechanic as well as a series of extra rules, such as new squares that imply new interactions to make the game more exciting online, kind of like how Town of Salem features more roles than the original game of Mafia.

 # Cool stuff
- [Nerves embedded/IoT](https://nerves-project.org/)

 
# Ideas: Extensibility, horizon -> Genomeur
 For GChess, I'd like to enable similar reasonable modifications to the rules. Those modifications will be optional and probably will be a lot like the lichess alternative game modes. I would prefer to make something that relates to dna in some way for chess so I can justify naming it GChess. So maybe some extra mechanics having to do with adenine (A), cytosine (C), guanine (G) and thymine (T). A pairs with T, C pairs with G. Maybe all pieces are assigned two short strings of base pairs and more complicated interactions ensue based on edited possible moves by the base-pairs? Or I could assign each type of piece a base pair string that produces the properties of that piece. Then mangle up the base pair strings of the pieces that are placed to make monstrosity pieces with unique behaviors. So a king could have the 'genome' of AAAAC TTTTG where the interaction between A and T at the spcific index indicates that the king cannot move into a space threatened by the opposing team and can move only one square in any of the 8 directions. A knight on the other hand could be holding the base pair chains of TAGCC TTGGC somewhow encoding that it can jump over pieces and can only move 1 and then two in a perpindicular direction. But his is hard to do. Still, it might present a good example for people to learn from ?
 
The physical and chemical interactions that make up biology and especially genomics are complicated, but also cool and increasingly important for people to have some grasp of (well, advances in biotech are increasingly relevant to people's lives).
I think it would be cool to make something to explain mRNA vaccines, GMOs, CRISPR technology, Gene Printing and other things that sound COOL, but require advanced knowledge of complex biological proccesses to understand somewhat wholly. Right now today, if you can pony up a couple hundred dollars, you can get a decent pass at your genome sequenced. And that's dope, but not very useful for you. I'd like to make something that would contribute to people's understanding of the complex processes that make themselves themselves, provide some light entertainment, and be able to introduce complicated realities of how organic life as we know it works, how mammals differ from other examples of multicellular life, and more.
 
Mostly I love the video game Spore. I played it so much as a kid, and it's not really about the mechanics of life on the small scale, but I like the idea of making a tiered game with multiple modes that actually has to do with the current understanding of how things work on the small scale. How you or I work when you start to look at our cells, or the zygote that leads to the version of you or I that exists now.
 
Now that's an ambitious idea, and I don't make games. But. If I can implement chess, I can definitely implement Ur (and Coup). And once those are done, I can show them to people or expose my app to the internet. And get some feedback. Was it worth it to take the time to make this? I dunno. When a release is done, then I might know.
 
A foundational problem could be - biomechanics may not be 'fun'. But any demo or game needs to have some fun for a user. So how much would one compromise the reality of biomechanics to make it fun? How much text can one cram into a little toy game before people ignore it? Would people actually be interested in playing a little game and learning about biology? They certainly would be less interested if it was only boring.
 
You could make the full implementation of Genomeur USE GChess as a subcomponent or mini-game within the larger Genomeur educational experience. To explain base pairs or basic recombination over generations. Then the implementation of Ur could attempt to explain the concepts behind mRNA transcription or actually decide the results of recombination say. (so play a game of ur real quick to decide the seed for the next game of GChess that gives each side the same pieces to play with whose properties are encoded in the seed, then the winning side somehow keeps their strategy and passes it on after recombination somehow? A little unclear on how this might work).
 
Anyway the idea is reasonable modifications to the rules of existing games for the purposes of biology deep-dive game called Genomeur. You play as a science person and the process of research is playing the minigames? Or it's a strategy based thing? Maybe the player of the game uses the base pair generation thing and the possible minigames and strategies are decided by some other biology concept that would be cool to learn about.
 
Shrug. I got excited by the whole genome sequencing thing a while ago and projects such as YFull that attempt to map people's Mitochondrial and Y Chromosome phenotype onto the whole of known and submitted human genomes. It would be cool to make stuff like that relevant to individuals in some other way than trying to determine your own personal ethnicity or personal ancestral lore or whatever. (ethnicity isn't really a concept supported by genetics as far as I can tell, but people are really into trying to make genetics support whatever ethnicity story they wish to tell). For example, I have a variant of MC1R that groups me with others that have red hair and not with 90% of people. I do not have red-looking hair but my mom does. Does this tell me anything about my ethnicity? I guess, but only because ethnicity is a story that we tell about groups of people. It allows you to tell a more convincing story, but only if you ignore the rest of the genetic diversity that you don't happen to care about (what shape is your foot? what's your fingerprint like? whats your blood type? How does all that relate to your genes? Oh we don't know? Huh) Ancestry is something that genetics is about. You inherit mostly unchanged versions of mitochondrial dna from the maternal line and the Y Chromosome's non-subject-to-recombination-parts from the paternal line). Ancestry could be intuitively confused with ethnicity, but it isn't really. People move around, and have always moved around. And mostly, there's a lot of unknowable things that genetics makes knowable. Somehow. Just how would be an interesting thing to make a little game about.
 
Alternative idea: A genomics-related game:
 - play as someone using software to browse the human genome
 - as you progress through learning about it, you establish goals and motivations for your research and discoveries that effect the game
 - It's all revealed later on as a representation of chess (or base pairs), where you have exactly as many options as there are possible moves in a game of chess, with each possibility. All the usual openings are enforced in the first phase of the game (like a learn how the actual game is to play, before you are shown the chess engine behind it, where you're just learning about genomics for a couple hours. Then you learn about chess because it is fun.)
 - I also want the player to be able to reference the yfull mtdna and y-dna tree and input their own haplogroup info or choose randomly and have this eventually effect the options within the game, but I have no idea on the details of that. It won't be accurate to the world in any way, just thought could be fun.

Moving through the game will be moving through the chromosomes (28 of them) and I want the first playthrough to provide a bunch of knowledge and resources to learn about genomics and the human genome and the different processes happening. Players will also be able to leave feedback at any point in the game (requests for new features or incorrect/out of date science or suggestions for more explanations etc). The point of the game is fun, but the byproduct, the lore of the game is actual science is the intent, or at least popular science summaries of current understandings of how the human genome works. REAL BIG TBD HERE, need Chess to be done first :).
