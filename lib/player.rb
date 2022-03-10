# frozen_string_literal: true

# Used store and reference each player's name and color
class Player
  attr_reader :name, :color

  def initialize(name, color)
    @name = name
    @color = color
  end
end
