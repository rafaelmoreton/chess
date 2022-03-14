# frozen_string_literal: true

require_relative 'pawn'

# Specify rules to find black pawn valid movements
class BPawn < Pawn
  attr_accessor :start_position

  def initialize(color)
    super
    @symbol = "\u2659"
    @start_position = true
  end

  def valid_moves(board)
    valid_ahead(board) +
      valid_start_jump(board) +
      valid_diagonal(board, 'left') +
      valid_diagonal(board, 'right')
  end

  def valid_ahead(board)
    self_coord = find_coordinates(board)
    ahead_position = shift_coordinates(self_coord, 0, -1)&.values&.join
    if ahead_position && board.find_square(ahead_position).occupant.nil?
      [ahead_position]
    else
      []
    end
  end

  def valid_start_jump(board)
    self_coord = find_coordinates(board)
    ahead_position = shift_coordinates(self_coord, 0, -1)&.values&.join
    jump_position = shift_coordinates(self_coord, 0, -2)&.values&.join
    ahead_square = board.find_square(ahead_position)
    jump_square = board.find_square(jump_position)
    if @start_position == true && jump_square &&
       ahead_square.occupant.nil? && jump_square.occupant.nil?
      [jump_position]
    else
      []
    end
  end

  def valid_diagonal(board, side)
    self_coord = find_coordinates(board)
    case side
    when 'left'
      diagonal = shift_coordinates(self_coord, -1, -1)
    when 'right'
      diagonal = shift_coordinates(self_coord, 1, -1)
    end
    return [] if diagonal.nil?

    diagonal_position = diagonal.values.join
    diagonal_occupant = board.find_square(diagonal_position).occupant
    if diagonal_occupant &&
       diagonal_occupant.color == 'white'
      [diagonal_position]
    else
      []
    end
  end
end
