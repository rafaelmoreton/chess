# frozen_string_literal: true

# Parent of every kind of piece's class (Pawn, King, etc.). It is used to store
# common attributes and methods.
class Piece
  attr_reader :color, :symbol

  def initialize(color)
    @color = color
  end

  def find_coordinates(board)
    piece_square = board.grid.reduce(:+).find do |square|
      square.occupant == self
    end
    piece_position = piece_square.position
    { column: piece_position[0], row: piece_position[1] }
  end

  def shift_coordinates(coord, column_shift, row_shift)
    shifted_column = (coord[:column].ord + column_shift).chr
    shifted_row = (coord[:row].ord + row_shift).chr
    if Array('a'..'h').none?(shifted_column) ||
       Array('1'..'8').none?(shifted_row)
      return nil
    end

    { column: shifted_column, row: shifted_row }
  end

  def find_direction_coordinates(
    direction,
    board,
    current_coord = find_coordinates(board),
    positions = []
  )
    next_coord = shift_coordinates(current_coord, direction[0], direction[1])
    return positions if next_coord.nil?

    next_square = board.find_square(next_coord.values.join)
    if next_square.occupant&.color == @color
      positions
    elsif next_square.occupant && next_square.occupant.color != @color
      positions << next_coord.values.join

    else
      positions << next_coord.values.join
      find_direction_coordinates(
        direction,
        board,
        next_coord,
        positions
      )
    end
  end
end
