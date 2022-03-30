# frozen_string_literal: true

require_relative 'square'

# Board objects are responsible for keeping track of an 8x8 grid of squares and
# the pieces that occupy them. The addition of pieces to the board pertains
# to the Board class because players seldom need to do it, since the initial
# set up is always the same.
class Board
  attr_reader :grid

  def initialize
    @grid = new_grid
  end

  def square(square_position)
    @grid.flatten.find { |square| square.position == square_position }
  end

  def show
    checkered_grid = @grid.map.with_index do |row, row_index|
      checkered_row(row, row_index)
    end
    reverse_index = 8
    wrapped_grid = checkered_grid.map do |row|

      row.push(" #{reverse_index}\n")
      row.unshift("#{reverse_index} ")
      reverse_index -= 1
      row
    end
    columns_index = ['   a  b  c  d  e  f  g  h']
    indexed_grid = columns_index + ["\n"] + wrapped_grid + columns_index

    puts indexed_grid.join
  end

  def add_piece(piece, position)
    square = square(position)
    square.occupant = piece
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
    row = []
    column_letter = 'a'
    8.times do
      position = column_letter + row_number.to_s
      row << Square.new(position)
      column_letter = column_letter.succ
    end
    row
  end

  def checkered_row(row, row_index)
    row.map.with_index do |square, sqr_index|
      if (row_index.even? && sqr_index.even?) ||
         (row_index.odd? && sqr_index.odd?)
        black_square(square.occupant)
      else
        blue_square(square.occupant)
      end
    end
  end

  def black_square(occupant)
    shown_occupant = occupant.nil? ? ' ' : occupant.symbol
    "\u001b[90m\e[1m\e[37m #{shown_occupant} \u001b[0m"
  end

  def blue_square(occupant)
    shown_occupant = occupant.nil? ? ' ' : occupant.symbol
    "\u001b[44m\e[1m\e[37m #{shown_occupant} \u001b[0m"
  end
end
