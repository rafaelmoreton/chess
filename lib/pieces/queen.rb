# frozen_string_literal: true

require_relative 'piece'

# Specify rules to find tower's valid movements
class Queen < Piece
  def initialize(color)
    super
    @symbol = color == 'white' ? "\u265b" : "\u2655"
  end

  def valid_moves(board)
    horizontal(board) +
    vertical(board) +
    up_diagonal(board) +
    down_diagonal(board)
  end

  def horizontal(board)
    left = find_direction_coordinates([-1, 0], board)
    right = find_direction_coordinates([1, 0], board)
    left + right
  end

  def vertical(board)
    up = find_direction_coordinates([0, 1], board)
    down = find_direction_coordinates([0, -1], board)
    up + down
  end

  def up_diagonal(board)
    left = find_direction_coordinates([-1, 1], board)
    right = find_direction_coordinates([1, 1], board)
    left + right
  end

  def down_diagonal(board)
    left = find_direction_coordinates([-1, -1], board)
    right = find_direction_coordinates([1, -1], board)
    left + right
  end
end
