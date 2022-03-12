# frozen_string_literal: true

require_relative 'piece'

class Tower < Piece
  def initialize(color)
    super
    @symbol = color == 'white' ? "\u265c" : "\u2656"
  end

  def horizontal
  end
end
