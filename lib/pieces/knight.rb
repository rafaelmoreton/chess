# frozen_string_literal: true

require_relative 'piece'

class Knight < Piece
  def initialize(color)
    super
    @symbol = color == 'white' ? "\u265e" : "\u2658"
    @piece_name = "Knight"
  end

  def valid_moves(board)
    valid = []
    leaping_positions(board).map do |position|
      occupant = board.square(position).occupant
      valid << position unless occupant&.color == @color
    end
    valid
  end

  def leaping_positions(board)
    self_coord = find_coordinates(board)
    all_coords = [
      [2, 1], [2, -1], [-2, 1], [-2, -1],
      [-1, 2], [1, 2], [-1, -2], [1, -2]
    ].map { |coord| shift_coordinates(self_coord, coord[0], coord[1]) }
    all_coords.delete(nil)
    all_coords.map(&:join)
  end
end
