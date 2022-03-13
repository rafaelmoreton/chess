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
      up = shift_coordinates(self_coord, 0, 1),
      down = shift_coordinates(self_coord, 0, -1),
      left = shift_coordinates(self_coord, -1, 0),
      right = shift_coordinates(self_coord, 1, 0),
      up_l = shift_coordinates(self_coord, -1, 1),
      up_r= shift_coordinates(self_coord, 1, 1),
      down_l = shift_coordinates(self_coord, -1, -1),
      down_r = shift_coordinates(self_coord, 1, -1)
    ]
    all_coords.delete(nil)
    all_coords.map do |coord|
      coord.values.join
    end
  end
end