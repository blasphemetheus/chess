# Chess
Distributed Implementation of Chess.
[![License](https://img.shields.io/badge/license-GPLv3-blue)](https://github.com/blasphemetheus/gchess/blob/main/LICENSE)

Play Chess over the network with custom visuals and a working referee, observers, etc. Start with the basic 'model' stuff, then move on to 'view' then 'controller'. This is kind of Object Oriented style but really I want this to be a software dev level project where I make a version of chess that can be played over a network. Doesn't need to be constrained to an OOD structure. Needs Test driven development ala Fundies 1 and 2 classes at NU Khoury. A functional programming language so some more difficulties, some benefits. Easy test running. Need automated players in some capacity, don't need to be too complicated. Running along the basic ideas of the course I took back in Fall 2019, Software Dev with Mathias  (https://felleisen.org/matthias/4500-f19/assignments.html) though the vesely documentation also would work as an outline (https://vesely.io/teaching/CS4500f19/).

# License
going with GPL-3.0-or-later
[![License](https://img.shields.io/badge/license-GPLv3-blue)](https://github.com/blasphemetheus/gchess/blob/main/LICENSE)

# Testing
Demonstrate how to run test harness.

Explain how to run complete set of internal unit tests And Individual unit tests

Try and do the basic process of good design by starting with unit tests, etc when actually writing the code.

# Test Me
We will maintain a script that can run all unit tests
- shell script or a short program in elixir
- document how to run script in README (check)
- Run script every time before a `git push`
- acceptable for test cases to fail, basic output of script is a couple lines of how many test cases ran, how many passed, how many failed, failing tests are fine during work on the project or if interupted, reminder where to resume
- not ok for unit testing to break things, reaise uncaught exception etc. if testing fails, script shows output for me to fix problesm

# Model

# View

For now a cli_view that walks a user through 

# Controller
honestly this doesn't translate 100% into a remote proxy server design, but the controller is the interaction over tcp between the client and server. The TCPServer is the closest thing to controller.

The first version of this will include hardcoded references between the view and board.
Then those references will be stripped out and replaced by interactions over tcp (via json packages communicated via the tcp_server)

# Components

roughly separated out into apps of an umbrella mix project. So the gchess project has the following components:
- cli_view
- board_model
- tcp_server
- referee
- TO (Tournament Organizer)

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