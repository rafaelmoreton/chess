# Chess
This is a command line chess game written in Ruby as the [final assignment](https://www.theodinproject.com/lessons/ruby-ruby-final-project) of the Odin Projects Ruby course.

## How to Play
This game can be played at your own computer's command line interface (CLI) or at an online one, like repl.it. The online alternative is only intended for demonstration purposes, thus having some limitations.

**Disclaimer:** the online option DOES NOT allow the game to be played between players at different computers across the internet. It simply allows the game to be played at an online browser. 

### Play Online
To play online simply open [this repl](https://replit.com/@rafaelmoreton/chess#), click on `run` and wait a few seconds for the game menu to appear

Altough playing online requires no setting up, be mindful that the play experience is going to be somewhat limited. The board colors will be slightly different and you won't be able to change the online CLI's font size. Most importantly the game cannot be saved when playing online.

### Play Offline
To play offline you need to have ruby >= 2.7.4 installed. Then simply clone this repo, navigate to it's directory (`cd chess`) and run the game (`ruby main.rb`).

### Game Controls
- To select one of your pieces, enter the coordinates that piece's square (example: a4).
- To Enter the coordinates of a square which is a valid move for the selected piece