# frozen_string_literal: true

require_relative 'piece'

# Specify rules to find tower's valid movements
class Bishop < Piece
  def initialize(color)
    super
    @symbol = color == 'white' ? "\u265d" : "\u2657"
  end

  def valid_moves(board)
    up(board) + down(board)
  end

  def up(board)
    left = find_direction_coordinates([-1, 1], board)
    right = find_direction_coordinates([1, 1], board)
    left + right
  end

  def down(board)
    left = find_direction_coordinates([-1, -1], board)
    right = find_direction_coordinates([1, -1], board)
    left + right
  end
end
