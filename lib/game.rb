# frozen_string_literal: true

require_relative 'board'

# Game objects are composed of a board object, two players and several chess
# pieces. The Game methods integrates those inner objects into an instance of
# game capable of running an entire chess match.
class Game
  def initialize
    @board = Board.new
    @selected_square = nil
  end

  def player_turn
    # select_square
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
end

test = Game.new
test.instance_variable_get(:@board).set_up_pieces
test.select_square('c2')
test.instance_variable_get(:@board).show
test.move_piece_to('c4')
test.instance_variable_get(:@board).show
