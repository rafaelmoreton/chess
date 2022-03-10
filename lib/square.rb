# frozen_string_literal: true

# Squares are created by Board#new_grid to represent the board squares with
# their respective positions on the board and a possible occupying piece.
class Square
  attr_reader :position
  attr_accessor :occupant

  def initialize(position)
    @position = position
    @occupant = nil
  end
end
