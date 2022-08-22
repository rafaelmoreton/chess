# frozen_string_literal: true

require_relative './lib/game'
require_relative './lib/serialize'

NEW_LOAD_TEXT = <<~NEW_LOAD_TEXT

  Start a new game or load a game?
  [n] New game
  [l] Load game
NEW_LOAD_TEXT

def new_load_prompt
  system('clear')
  puts NEW_LOAD_TEXT
  case gets.chomp
  when 'n'
    puts "\nNew game starting..."
    sleep(1)
    game = Game.new
    game.set_up_pieces
    game.new_players
    game.turn
  when 'l'
    puts "\nNew game loading..."
    sleep(1)
    Game.load_game
  else
    new_load_prompt
  end
end

puts 'Chess game started'
sleep(1)
loop do
  new_load_prompt
end
