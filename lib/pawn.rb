# frozen_string_literal: true

require_relative 'piece'

class Pawn < Piece
  attr_reader :symbol
  attr_accessor :start_position

  def initialize(color)
    super
    @symbol = color == 'black' ? "\u2659" : "\u265f"
    @start_position = true
  end

  def valid_moves(board)
    piece_square = board.grid.reduce(:+).find do |square|
      square.occupant == self
    end
    piece_column = piece_square.position.split('').first
    piece_row = piece_square.position.split('').last
    valid_moves = []

    case @color
    when 'white'
      position_one_above = piece_column + piece_row.succ
      square_one_above = board.grid.reduce(:+).find do |square|
        square.position == position_one_above
      end
      if square_one_above.occupant.nil?
        valid_moves << position_one_above
      end

      if @start_position == true &&
         square_one_above.occupant.nil?
        position_two_above = piece_column + piece_row.succ.succ
        valid_moves << position_two_above
      end

      position_diagonal_above_r = piece_column.ord.succ.chr + piece_row.succ
      position_diagonal_above_l = piece_column.ord.pred.chr + piece_row.succ
      position_diagonals_above = [
        position_diagonal_above_r,
        position_diagonal_above_l
      ]
      position_diagonals_above.each do |diagonal|
        diagonal_square = board.grid.reduce(:+).find do |square|
          square.position == diagonal
        end
        if diagonal_square.occupant &&
           diagonal_square.color == 'black'
          valid_moves << diagonal
        end
      end

    when 'black'
      position_one_below = piece_column + piece_row.to_i.pred.to_s
      square_one_below = board.grid.reduce(:+).find do |square|
        square.position == position_one_below
      end
      if square_one_below.occupant.nil?
        valid_moves << position_one_below
      end

      if @start_position == true &&
         square_one_below.occupant.nil?
        position_two_below = piece_column + piece_row.to_i.pred.pred.to_s
        valid_moves << position_two_below
      end
    end

    position_diagonal_below_r = piece_column.ord.succ.chr +
                                piece_row.to_i.pred.to_s
    position_diagonal_below_l = piece_column.ord.pred.chr +
                                piece_row.to_i.pred.to_s
    position_diagonals_below = [
      position_diagonal_below_r,
      position_diagonal_below_l
    ]
    position_diagonals_below.each do |diagonal|
      diagonal_square = board.grid.reduce(:+).find do |square|
        square.position == diagonal
      end
      if diagonal_square.occupant &&
         diagonal_square.color == 'white'
        valid_moves << diagonal
      end
    end

    valid_moves
  end
end
