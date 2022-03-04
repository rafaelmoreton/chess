# frozen_string_literal: true

class Board
  def initialize
    @grid = new_grid
  end

  def new_grid
    grid = {}
    row_letter = 'a'
    8.times do
      grid = grid.merge(new_row(row_letter))
      row_letter = row_letter.succ
    end
    grid
  end

  def new_row(letter)
    row = {}
    column = '1'
    8.times do
      position = (letter + column).to_sym
      row[position] = nil
      column = column.succ
    end
    row
  end
end
