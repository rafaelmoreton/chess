# frozen_string_literal: true

require_relative 'piece'

class Pawn < Piece
  attr_reader :symbol

  def initialize(color)
    super
    @symbol = color == 'black' ? "\u2659" : "\u265f"
  end
end
