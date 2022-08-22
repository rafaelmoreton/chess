# frozen_string_literal: true

# Parent of every kind of piece's class (Pawn, King, etc.). It is used to store
# common attributes and methods.
class Piece
  attr_reader :color, :symbol, :piece_name

  def initialize(color)
    @color = color
  end

  def find_coordinates(board)
    piece_square = board.grid.reduce(:+).find do |square|
      square.occupant == self
    end
    piece_position = piece_square.position
    [piece_position[0], piece_position[1]]
  end

  def shift_coordinates(coord, column_shift, row_shift)
    shifted_column = (coord[0].ord + column_shift).chr
    shifted_row = (coord[1].ord + row_shift).chr
    if Array('a'..'h').none?(shifted_column) ||
       Array('1'..'8').none?(shifted_row)
      return nil
    end

    [shifted_column, shifted_row]
  end

  def find_direction_coordinates(
    direction,
    board,
    current_coord = find_coordinates(board),
    positions = []
  )
    next_coord = shift_coordinates(current_coord, direction[0], direction[1])
    return positions if next_coord.nil?

    next_square = board.square(next_coord.join)
    if next_square.occupant&.color == @color
      positions
    elsif next_square.occupant && next_square.occupant.color != @color
      positions << next_coord.join

    else
      positions << next_coord.join
      find_direction_coordinates(
        direction,
        board,
        next_coord,
        positions
      )
    end
  end
end
