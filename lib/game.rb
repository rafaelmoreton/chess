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
      @selected_square.occupant = nil
      if target_square.occupant.is_a?(Pawn)
        target_square.occupant.start_position = false
        target_square.occupant.promotion(@board)
      end
      @selected_square = nil
    end
  end

  def choose_name(player_color)
    puts "choose a name for #{player_color} color player"
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
      move_piece_to(move_input) if move_check?(player, move_input)
    end
  end

  # rubocop:disable Metrics/MethodLength
  def selection_check?(player, input)
    selected_sqr = @board.find_square(input)
    if selected_sqr.nil?
      puts 'invalid input'
      false
    elsif selected_sqr.occupant.nil? ||
          selected_sqr.occupant&.color != player.color
      puts "there is no #{player.color} piece on this square"
      false
    else
      true
    end
  end

  def move_check?(player, input)
    target_sqr = @board.find_square(input)
    if input == '' # when input is empty select another square
      puts 'deselected square, select another'
      @selected_square = nil
      until @selected_square
        input = gets.chomp
        select_square(input) if selection_check?(player, input)
      end
    elsif target_sqr.nil?
      puts 'invalid target'
      false
    elsif target_sqr.occupant&.color == @selected_square.occupant.color ||
          @selected_square.occupant.valid_moves(@board).none? do |move|
            target_sqr.position == move
          end
      puts 'invalid move'
      false
    elsif exposing_move?(player, target_sqr)
      puts "You cannot let your king in check"
      false
    else
      true
    end
  end
  # rubocop:enable Metrics/MethodLength

  def turn
    loop do
      player_turn(@white)
      @board.show
      if check?('black')
        return puts "checkmate, white player win" if checkmate?('black')

        puts "black king is in check" 
      end
      player_turn(@black)
      @board.show
      if check?('white')
        return puts "checkmate, black player win" if checkmate?('white')

        puts "white king is in check" 
      end
    end
  end

  def check?(color)
    king_position = nil
    threat_moves = []
    @board.grid.flatten.each do |square|
      if square.occupant && square.occupant.color != color
        threat_moves << square.occupant&.valid_moves(@board)
      elsif square.occupant.is_a?(King) && square.occupant.color == color
        king_position = square.position
      end
    end
    threat_moves.flatten.uniq.any?(king_position)
  end

  def checkmate?(color)
    @board.grid.flatten.each do |square|
      if square.occupant&.color == color
        return false if check_avoidable_by?(square.occupant, color)
      end
    end
    true
  end

  def check_avoidable_by?(piece, color)
    original_position = piece.find_coordinates(@board).values.join
    original_square = @board.find_square(original_position)

    piece.valid_moves(@board).each do |move_position|
      move_square = @board.find_square(move_position)
      move_occupant = move_square.occupant

      move_square.occupant = piece
      original_square.occupant = nil

      unless check?(color)
        original_square.occupant = piece
        move_square.occupant = move_occupant
        return true
      end

      original_square.occupant = piece
      move_square.occupant = move_occupant
    end
    false
  end

  def exposing_move?(player, move_square)
    move_square.occupant = @selected_square.occupant
    @selected_square.occupant = nil
    result = check?(player.color)
    @selected_square.occupant = move_square.occupant
    move_square.occupant = nil
    result
  end
end
