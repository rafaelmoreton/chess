# frozen_string_literal: true

require_relative 'square'

class Board
  attr_reader :grid

  def initialize
    @grid = new_grid
  end

  def new_grid
    grid = []
    row_letter = 8
    8.times do
      grid << new_row(row_letter)
      row_letter = row_letter.pred
    end
    grid
  end

  def show
    checkered_grid = @grid.map.with_index do |row, row_index|
      if row_index.even?
        row.map.with_index do |_square, sqr_index|
          if sqr_index.even?
            black_square(" ")
          else
            blue_square(" ")
          end
        end
      else
        row.map.with_index do |_square, sqr_index|
          if sqr_index.odd?
            black_square(" ")
          else
            blue_square(" ")
          end
        end
      end
    end
    wrapped_grid = checkered_grid.map do |row|
      row[-1] += "\n"
      row
    end
    puts wrapped_grid.join
  end

  def add_piece(piece, position) end

  private

  def new_row(letter)
    row = []
    column = 'a'
    8.times do
      position = column + letter.to_s
      row << Square.new(position)
      column = column.succ
    end
    row
  end

  def black_square(occupant)
    "\u001b[90m\e[1m\e[37m #{occupant} \u001b[0m"
  end

  def blue_square(occupant)
    "\u001b[44m\e[1m\e[37m #{occupant} \u001b[0m"
  end
end
