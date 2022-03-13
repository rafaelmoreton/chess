# frozen_string_literal: true

require_relative 'square'
require_relative './pieces/piece'
require_relative './pieces/w_pawn'
require_relative './pieces/b_pawn'
require_relative './pieces/tower'
require_relative './pieces/bishop'
require_relative './pieces/queen'
require_relative './pieces/king'

# Board objects are responsible for keeping track of an 8x8 grid of squares and
# the pieces that occupy them. The addition of pieces to the board pertains
# to the Board class because players seldom need to do it, since the initial
# set up is always the same.
class Board
  attr_reader :grid

  def initialize
    @grid = new_grid
  end

  def find_square(square_position)
    @grid.flatten.find { |square| square.position == square_position }
  end

  def show
    checkered_grid = @grid.map.with_index do |row, row_index|
      checkered_row(row, row_index)
    end
    wrapped_grid = checkered_grid.map do |row|
      row[-1] += "\n"
      row
    end
    puts wrapped_grid.join
  end

  def add_piece(piece, position)
    square = find_square(position)
    square.occupant = piece
  end

  def set_up_pieces
    row2 = %w[a2 b2 c2 d2 e2 f2 g2 h2]
    row2.each { |position| add_piece(WPawn.new('white'), position) }
    row7 = %w[a7 b7 c7 d7 e7 f7 g7 h7]
    row7.each { |position| add_piece(BPawn.new('black'), position) }
    %w[a1 h1].each { |position| add_piece(Tower.new('white'), position) }
    %w[a8 h8].each { |position| add_piece(Tower.new('black'), position) }
    %w[c1 f1].each { |position| add_piece(Bishop.new('white'), position) }
    %w[c8 f8].each { |position| add_piece(Bishop.new('black'), position) }
    add_piece(Queen.new('white'), 'd1')
    add_piece(Queen.new('black'), 'd8')
    add_piece(King.new('white'), 'e1')
    add_piece(King.new('black'), 'e8')
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
