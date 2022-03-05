# frozen_string_literal: true

class Board
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
    checkered_board = @grid.map.with_index do |row, row_index|
      if row_index.even?
        row.map.with_index do |_square, sqr_index|
          if sqr_index.even?
            "\e[1m\u001b[90m\e[37m   \u001b[0m\e[0m"
          else
            "\e[1m\u001b[44m\e[37m   \u001b[0m\e[0m"
          end
        end
      else
        row.map.with_index do |_square, sqr_index|
          if sqr_index.odd?
            "\e[1m\u001b[90m\e[37m   \u001b[0m\e[0m"
          else
            "\e[1m\u001b[44m\e[37m   \u001b[0m\e[0m"
          end
        end
      end
    end
    wrapped_board = checkered_board.map do |row|
      row[-1] += "\n"
      row
    end
    puts wrapped_board.join
  end

  private

  def new_row(letter)
    row = []
    column = 'a'
    8.times do
      position = letter.to_s + column
      row << position
      column = column.succ
    end
    row
  end
end
