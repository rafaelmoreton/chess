# frozen_string_literal: true

require_relative 'square'
require_relative 'piece'
require_relative 'pawn'

# Board objects are responsible for keeping track of an 8x8 grid of squares and
# the pieces that occupy them. The addition of pieces to the board pertains
# to the Board class because players seldom need to do it, since the initial
# set up is always the same.
class Board
  attr_reader :grid

  def initialize
    @grid = new_grid
  end

  def show
    checkered_grid = @grid.map.with_index do |row, row_index|
      if row_index.even?
        row.map.with_index do |square, sqr_index|
          if sqr_index.even?
            black_square(square.occupant)
          else
            blue_square(square.occupant)
          end
        end
      else
        row.map.with_index do |square, sqr_index|
          if sqr_index.odd?
            black_square(square.occupant)
          else
            blue_square(square.occupant)
          end
        end
      end
    end
    wrapped_grid = checkered_grid.map do |row|
      row[-1] += "\n"
      row
    end
    puts wrapped_grid.join
  end

  def add_piece(piece, position)
    grid.reduce(:+).each do |square|
      if square.position == position
        square.occupant = piece
      end
    end
  end

  def set_up_pieces
    add_piece(Pawn.new('white'), 'a2')
    add_piece(Pawn.new('white'), 'b2')
    add_piece(Pawn.new('white'), 'c2')
    add_piece(Pawn.new('white'), 'd2')
    add_piece(Pawn.new('white'), 'e2')
    add_piece(Pawn.new('white'), 'f2')
    add_piece(Pawn.new('white'), 'g2')
    add_piece(Pawn.new('white'), 'h2')
  end

  private

  def new_grid
    grid = []
    row_number = 8
    8.times do
      grid << new_row(row_number)
      row_number = row_number.pred
    end
    grid
  end

  def new_row(row_number)
    column = []
    column_letter = 'a'
    8.times do
      position = column_letter + row_number.to_s
      column << Square.new(position)
      column_letter = column_letter.succ
    end
    column
  end

  def black_square(occupant)
    "\u001b[90m\e[1m\e[37m #{occupant.is_a?(Piece) ? occupant.symbol : " "} \u001b[0m"
  end

  def blue_square(occupant)
    "\u001b[44m\e[1m\e[37m #{occupant.is_a?(Piece) ? occupant.symbol : " "} \u001b[0m"
  end
end
