# frozen_string_literal: true

require_relative 'piece'

# Specify rules to find tower's valid movements
class King < Piece
  attr_accessor :start_position

  def initialize(color)
    super
    @symbol = color == 'white' ? "\u265a" : "\u2654"
    @start_position = true
    @piece_name = "King"
  end

  def valid_moves(board)
    valid = []
    adjacent_positions(board).map do |position|
      occupant = board.square(position).occupant
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
    all_coords.map(&:join)
  end

  def castle(board, king_move)
    leaped_sqr_column = (
      (king_move[0].ord + find_coordinates(board)[0].ord) / 2
    ).chr
    leaped_sqr = board.square(leaped_sqr_column + king_move[1])
    find_towers(board).map do |tower|
      next unless tower.horizontal(board).any?(leaped_sqr.position)

      tower_square = board.square(tower.find_coordinates(board).join)
      leaped_sqr.occupant = tower
      tower_square.occupant = nil
    end
  end

  def castling_moves(board)
    return [] if @start_position == false

    self_coord = find_coordinates(board)
    all_coords = [[2, 0], [-2, 0]].map do |coord|
      king_move_coord = shift_coordinates(self_coord, coord[0], coord[1])
      tower_arrival_column = coord[0] + (coord[0].positive? ? -1 : 1)
      tower_arrival_coord = shift_coordinates(
        self_coord, tower_arrival_column, coord[1]
      )
      towers_line_moves = find_towers(board).map do |tower|
        tower.horizontal(board)
      end.flatten
      king_move_coord.join if towers_line_moves.any?(tower_arrival_coord.join)
    end
    all_coords.delete(nil)
    all_coords
  end

  def find_towers(board)
    towers = []
    board.grid.flatten.map do |square|
      next unless square.occupant.is_a?(Tower) &&
                  square.occupant.color == color &&
                  square.occupant.start_position == true

      towers << square.occupant
    end
    towers
  end
end
