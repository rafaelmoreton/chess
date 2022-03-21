# frozen_string_literal: true

require_relative 'piece'

# Specify rules to find tower's valid movements
class King < Piece
  def initialize(color)
    super
    @symbol = color == 'white' ? "\u265a" : "\u2654"
  end

  def valid_moves(board)
    valid = []
    adjacent_positions(board).map do |position|
      occupant = board.find_square(position).occupant
      valid << position unless occupant&.color == @color
    end
    valid
  end

  def adjacent_positions(board)
    self_coord = find_coordinates(board)
    all_coords = [
      [0, 1], [0, -1], [-1, 0], [1, 0],
      [-1, 1], [1, 1], [-1, -1], [1, -1]
    ].map { |coord| shift_coordinates(self_coord, coord[0], coord[1]) }
    all_coords.delete(nil)
    all_coords.map do |coord|
      coord.join
    end
  end
end
