# frozen_string_literal: true

require_relative 'pawn'

# Specify rules to find white pawn valid movements
class WPawn < Pawn
  attr_accessor :start_position

  def initialize(color)
    super
    @symbol = "\u265f"
    @start_position = true
  end

  def valid_moves(board)
    valid_ahead(board) +
      valid_start_jump(board) +
      valid_diagonal(board, 'left') +
      valid_diagonal(board, 'right')
  end

  def valid_ahead(board)
    coord = find_coordinates(board)
    ahead = coord[:column] + coord[:row].succ
    square_ahead = board.find_square(ahead)
    square_ahead.occupant.nil? ? [ahead] : []
  end

  def valid_start_jump(board)
    coord = find_coordinates(board)
    ahead = coord[:column] + coord[:row].succ
    jump = coord[:column] + coord[:row].succ.succ
    square_ahead = board.find_square(ahead)
    square_jump = board.find_square(jump)
    if square_ahead.occupant.nil? && square_jump.occupant.nil? &&
       @start_position == true
      [jump]
    else
      []
    end
  end

  def valid_diagonal(board, side)
    coord = find_coordinates(board)
    case side
    when 'left'
      diagonal = coord[:column].ord.pred.chr + coord[:row].succ
    when 'right'
      diagonal = coord[:column].ord.succ.chr + coord[:row].succ
    end
    diagonal_occupant = board.find_square(diagonal).occupant
    valid = []
    if diagonal_occupant &&
       diagonal_occupant.color == 'black'
      valid << diagonal
    end
    valid
  end
end
