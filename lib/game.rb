# frozen_string_literal: true

require_relative 'board'
require_relative 'player'

# Game objects are composed of a board object, two players and several chess
# pieces. The Game methods integrates those inner objects into an instance of
# game capable of running an entire chess match.
class Game
  def initialize
    @board = Board.new
    @selected_square = nil
    @white = nil
    @black = nil
  end

  def select_square(position)
    @board.grid.reduce(:+).each do |square|
      if square.position == position
        @selected_square = square
      end
    end
  end

  def move_piece_to(target)
    @board.grid.reduce(:+).each do |square|
      if square.position == target
        square.occupant = @selected_square.occupant
        @selected_square.occupant = nil
      end
    end
  end

  def choose_name(player_color)
    case player_color
    when 'white'
      puts 'choose a name for first player, white color'
    when 'black'
      puts 'choose a name for second player, black color'
    end
    loop do
      player_input = gets.chomp
      return player_input unless player_input.empty?

      puts 'enter something'
    end
  end

  def new_players
    white_name = choose_name('white')
    black_name = choose_name('black')
    @white = Player.new(white_name, 'white')
    @black = Player.new(black_name, 'black')
  end

  def player_turn(player)
    puts "it is #{player.name}' turn"
    select_square(gets.chomp)
    move_piece_to(gets.chomp)
  end

  def turn
    loop do
      player_turn(@white)
      @board.show
      player_turn(@black)
      @board.show
    end
  end
end

test = Game.new
test.instance_variable_get(:@board).set_up_pieces
test.select_square('c2')
test.instance_variable_get(:@board).show
test.move_piece_to('c4')
test.instance_variable_get(:@board).show
test.new_players
test.instance_variable_get(:@board).show
test.turn
