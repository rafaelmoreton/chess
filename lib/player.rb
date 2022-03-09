# frozen_string_literal: true

# Used to get players's inputs
class Player
  attr_reader :name, :color

  def initialize(name, color)
    @name = name
    @color = color
  end
end
