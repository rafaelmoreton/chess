# frozen_string_literal: true

require_relative 'board'
require_relative 'player'

# Game objects are composed of a board object, two players and several chess
# pieces. The Game methods integrates those inner objects into an instance of
# game capable of running an entire chess match.
class Game
  def initialize
    @board = Board.new
    @selected_square = nil
    @white = nil
    @black = nil
  end

  def select_square(position)
    @board.grid.reduce(:+).each do |square|
      @selected_square = square if square.position == position
    end
  end

  def move_piece_to(target)
    @board.grid.reduce(:+).each do |target_square|
      next unless target_square.position == target

      target_square.occupant = @selected_square.occupant
      if target_square.occupant.is_a?(Pawn)
        target_square.occupant.start_position = false
      end
      @selected_square.occupant = nil
      @selected_square = nil
    end
  end

  def choose_name(player_color)
    case player_color
    when 'white'
      puts 'choose a name for first player, white color'
    when 'black'
      puts 'choose a name for second player, black color'
    end
    loop do
      player_input = gets.chomp
      return player_input unless player_input.empty?

      puts 'enter something'
    end
  end

  def new_players
    white_name = choose_name('white')
    black_name = choose_name('black')
    @white = Player.new(white_name, 'white')
    @black = Player.new(black_name, 'black')
  end

  def player_turn(player)
    puts "it is #{player.name}' turn"
    until @selected_square
      select_input = gets.chomp
      select_square(select_input) if selection_check?(player, select_input)
    end
    until @selected_square.nil?
      move_input = gets.chomp
      move_piece_to(move_input) if move_check?(move_input)
    end
  end

  def selection_check?(player, input)
    target_square = @board.grid.reduce(:+).find do |square|
      square.position == input
    end
    if target_square.nil?
      puts 'invalid input'
      false
    elsif target_square.occupant.nil? ||
          target_square.occupant&.color != player.color
      puts "there is no #{player.color} piece on this square"
      false
    else
      true
    end
  end

  def move_check?(input)
    target_square = @board.grid.reduce(:+).find do |square|
      square.position == input
    end
    if target_square.nil?
      puts 'invalid target'
      false
    elsif target_square.occupant&.color == @selected_square.occupant.color ||
          @selected_square.occupant.valid_moves(@board).none? do |move|
            target_square.position == move
          end
      puts 'invalid move'
      false
    else
      true
    end
  end

  def turn
    loop do
      player_turn(@white)
      @board.show
      player_turn(@black)
      @board.show
    end
  end
end
