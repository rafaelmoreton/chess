# frozen_string_literal: true

require_relative 'piece'

# Specify rules to find tower's valid movements
class Tower < Piece
  attr_accessor :start_position

  def initialize(color)
    super
    @symbol = color == 'white' ? "\u265c" : "\u2656"
    @start_position = true
    @piece_name = "Tower"
  end

  def valid_moves(board)
    horizontal(board) + vertical(board)
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
end
