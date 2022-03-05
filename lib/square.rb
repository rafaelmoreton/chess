# frozen_string_literal: true

class Square
  attr_reader :position
  attr_accessor :occupant

  def initialize(position)
    @position = position
    @occupant = nil
  end
end
