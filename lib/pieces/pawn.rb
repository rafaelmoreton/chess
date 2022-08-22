# frozen_string_literal: true

require_relative 'piece'

class Pawn < Piece
  def initialize(color)
    super
    @piece_name = "Pawn"
  end

  def promotion(board)
    if @color == 'white'
      promotion_squares = %w[a8 b8 c8 d8 e8 f8 g8 h8]
    else
      promotion_squares = %w[a1 b1 c1 d1 e1 f1 g1 h1]
    end
    position = find_coordinates(board).join
    square = board.square(position)
    return if promotion_squares.none?(position)

    puts <<~PROMOTION
      Pawn promoted. What piece should it become?
      [q] Queen
      [b] Bishop
      [t] Tower
      [k] Knight
    PROMOTION
    until square.occupant != self
      input = gets.chomp
      square.occupant =
        case input
        when 'q'
          Queen.new(@color)
        when 'b'
          Bishop.new(@color)
        when 't'
          Tower.new(@color)
        when 'k'
          Knight.new(@color)
        else
          puts 'invalid input'
          self
        end
    end
  end
end
