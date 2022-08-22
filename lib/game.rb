# frozen_string_literal: true

# rubocop: disable Lint/NonDeterministicRequireOrder

require_relative 'board'
require_relative 'player'
require_relative 'serialize'
Dir[File.join(__dir__, 'pieces', '*.rb')].each do |piece_file|
  require piece_file
end

# Game objects are composed of a board object, two players and several chess
# pieces. The Game methods integrates those inner objects into an instance of
# game capable of running an entire chess match.
class Game
  extend Serialize

  def initialize
    @board = Board.new
    @selected_square = nil
    @white = nil
    @black = nil
  end

  def new_players
    white_name = choose_name('white')
    black_name = choose_name('black')
    @white = Player.new(white_name, 'white')
    @black = Player.new(black_name, 'black')
    @active_player = @white
    @inactive_player = @black
  end

  def choose_name(player_color)
    system('clear')
    loop do
      puts "Choose a name for the #{player_color} pieces player"
      player_input = gets.chomp
      return player_input unless player_input.empty?
    end
  end

  def set_up_pieces
    row2 = %w[a2 b2 c2 d2 e2 f2 g2 h2]
    row2.each { |position| @board.add_piece(WPawn.new('white'), position) }
    row7 = %w[a7 b7 c7 d7 e7 f7 g7 h7]
    row7.each { |position| @board.add_piece(BPawn.new('black'), position) }
    %w[a1 h1].each { |position| @board.add_piece(Tower.new('white'), position) }
    %w[a8 h8].each { |position| @board.add_piece(Tower.new('black'), position) }
    %w[c1 f1].each { |position| @board.add_piece(Bishop.new('white'), position) }
    %w[c8 f8].each { |position| @board.add_piece(Bishop.new('black'), position) }
    %w[b1 g1].each { |position| @board.add_piece(Knight.new('white'), position) }
    %w[b8 g8].each { |position| @board.add_piece(Knight.new('black'), position) }
    @board.add_piece(Queen.new('white'), 'd1')
    @board.add_piece(Queen.new('black'), 'd8')
    @board.add_piece(King.new('white'), 'e1')
    @board.add_piece(King.new('black'), 'e8')
  end

  def turn
    loop do
      @board.show
      puts "#{@active_player.color.capitalize} king is in check" if check?(@active_player.color)
      return Game.load_game if player_turn(@active_player) == 'loadgame'
      # Here player turn has already switched active and inactive players
      next unless check?(@active_player.color)
      if checkmate?(@active_player.color)
        puts "Checkmate, #{@inactive_player.name} win"
        sleep(2)
        return
      end
    end
  end

  def player_turn(player)
    puts "\n#{player.name}'s turn"
    until @selected_square
      puts "Select a piece"
      select_input = gets.chomp
      case select_input
      when 'save'
        Game.save_game(self)
        select_input = gets.chomp
      when 'load'
        return 'loadgame'
      end
      select_square(select_input) if selection_check?(player, select_input)
    end
    until @selected_square.nil?
      puts "Move #{@selected_square.position} #{@selected_square.occupant.piece_name}"
      move_input = gets.chomp
      case move_input
      when 'save'
        Game.save_game(self)
        move_input = gets.chomp
      when 'load'
        return 'loadgame'
      end
      move_piece_to(move_input) if move_check?(player, move_input)
    end

    @active_player = @inactive_player
    @inactive_player = player
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
      piece = target_square.occupant
      @selected_square.occupant = nil
      piece.promotion(@board) if piece.is_a?(Pawn)
      piece.start_position = false if piece.respond_to?(:start_position)
      @selected_square = nil
    end
  end

  # rubocop:disable Metrics/MethodLength
  def selection_check?(player, input)
    system('clear')
    puts @board.show
    selected_sqr = @board.square(input)
    if selected_sqr.nil?
      puts 'This is not a valid square'
      false
    elsif selected_sqr.occupant.nil? ||
          selected_sqr.occupant&.color != player.color
      puts "There is no #{player.color} piece on this square"
      false
    else
      true
    end
  end

  def move_check?(player, input)
    system('clear')
    puts @board.show
    target_sqr = @board.square(input)
    if input == '' # when input is empty select another square
      reselect_square(player)
    elsif target_sqr.nil?
      puts "Invalid move"
      false
    elsif castling_move?(target_sqr.position)
      puts 'Castling'
      sleep(1)
      @selected_square.occupant.castle(@board, target_sqr.position)
      true
    elsif invalid_move?(target_sqr)
      puts 'Invalid move'
      false
    elsif exposing_move?(player, target_sqr)
      puts 'You cannot place or leave your king in check'
      false
    else
      true
    end
  end
  # rubocop:enable Metrics/MethodLength

  def castling_move?(move_target)
    @selected_square.occupant.is_a?(King) &&
      @selected_square.occupant.castling_moves(@board).any? do |move|
        move_target == move
      end
  end

  def invalid_move?(target_sqr)
    target_sqr.occupant&.color == @selected_square.occupant.color ||
      @selected_square.occupant.valid_moves(@board).none? do |move|
        target_sqr.position == move
      end
  end

  def reselect_square(player)
    puts "#{@selected_square.occupant.piece_name} at #{@selected_square.position} deselected"
    @selected_square = nil
    until @selected_square
      puts "Select a piece"
      input = gets.chomp
      select_square(input) if selection_check?(player, input)
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
      if square.occupant&.color == color &&
         check_avoidable_by?(square.occupant)
        return false
      end
    end
    true
  end

  def check_avoidable_by?(piece)
    original_position = piece.find_coordinates(@board).join
    original_square = @board.square(original_position)

    piece.valid_moves(@board).each do |move_position|
      move_square = @board.square(move_position)
      return true if saving_move?(original_square, move_square, piece)
    end
    false
  end

  def saving_move?(original_square, move_square, piece)
    original_move_square_occupant = move_square.occupant
    move_square.occupant = piece
    original_square.occupant = nil
    result = check?(piece.color) ? false : true
    move_square.occupant = original_move_square_occupant
    original_square.occupant = piece
    result
  end

  def exposing_move?(player, move_square)
    original_move_square_occupant = move_square.occupant
    move_square.occupant = @selected_square.occupant
    @selected_square.occupant = nil
    result = check?(player.color)
    @selected_square.occupant = move_square.occupant
    move_square.occupant = original_move_square_occupant
    result
  end
end

# rubocop: enable Lint/NonDeterministicRequireOrder
