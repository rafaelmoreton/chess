# frozen_string_literal: true

require_relative 'piece'

class Knight < Piece
  def initialize(color)
    super
    @symbol = color == 'white' ? "\u265e" : "\u2658"
  end

  def valid_moves(board)
    valid = []
    leaping_positions(board).map do |position|
      occupant = board.find_square(position).occupant
      valid << position unless occupant&.color == @color
    end
    valid
  end

  def leaping_positions(board)
    self_coord = find_coordinates(board)
    all_coords = [
      shift_coordinates(self_coord, 2, 1),
      shift_coordinates(self_coord, 2, -1),
      shift_coordinates(self_coord, -2, 1),
      shift_coordinates(self_coord, -2, -1),
      shift_coordinates(self_coord, -1, 2),
      shift_coordinates(self_coord, 1, 2),
      shift_coordinates(self_coord, -1, -2),
      shift_coordinates(self_coord, 1, -2)
    ]
    all_coords.delete(nil)
    all_coords.map do |coord|
      coord.values.join
    end
  end
end

