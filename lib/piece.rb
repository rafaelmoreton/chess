# frozen_string_literal: true

# Parent of every kind of piece's class (Pawn, King, etc.). It is used to store
# common attributes and methods.
class Piece
  attr_reader :color

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
end
