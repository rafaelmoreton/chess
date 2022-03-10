# frozen_string_literal: true

# Parent of every kind of piece's class (Pawn, King, etc.). It is used to store
# common attributes and methods.
class Piece
  attr_reader :color

  def initialize(color)
    @color = color
  end
end
