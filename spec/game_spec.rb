# frozen_string_literal: true

require_relative '../lib/game'

describe Game do
  subject(:game) { described_class.new }
  let(:board) { game.instance_variable_get(:@board) }
  let(:squares) { board.grid.reduce(:+) }

  describe '#move_piece_to' do
    context 'when a square is selected and the target input is valid' do
      position_to_select = 'c2'
      target_input = 'c4'
      let(:selected_sqr) do
        squares.find { |sqr| sqr.position == position_to_select }
      end
      let(:target_sqr) do
        squares.find { |sqr| sqr.position == target_input }
      end
      before do
        game.set_up_pieces
        game.instance_variable_set(:@selected_square, selected_sqr)
      end

      it 'makes moved piece the new target square occupant' do
        moved_piece = selected_sqr.occupant

        game.move_piece_to(target_input)
        expect(target_sqr.occupant).to eq moved_piece
      end

      it "assigns 'nil' as the new selected square occupant" do
        game.move_piece_to(target_input)
        expect(selected_sqr.occupant).to be nil
      end
    end
  end

  describe '#selection_check?' do
    let(:player) { double('white_player', color: 'white') }
    context 'when player input is invalid' do
      it 'outputs invalid input warn and returns false' do
        warn = 'invalid input'
        expect(game).to receive(:puts).with(warn).once
        invalid_input = '99'
        result = game.selection_check?(player, invalid_input)
        expect(result).to be false
      end
    end

    context 'when player input is valid but there is no piece on that square' do
      it 'outputs invalid selection warn and returns false' do
        warn = "there is no #{player.color} piece on this square"
        expect(game).to receive(:puts).with(warn).once
        valid_input = 'd5'
        result = game.selection_check?(player, valid_input)
        expect(result).to be false
      end
    end

    context 'when player input is valid and there is a piece on that square,
    but it is of a different color than the player' do
      before do
        game.set_up_pieces
      end
      it 'outputs invalid selection warn and returns false' do
        warn = "there is no #{player.color} piece on this square"
        expect(game).to receive(:puts).with(warn).once
        not_your_piece_input = 'd7'
        result = game.selection_check?(player, not_your_piece_input)
        expect(result).to be false
      end
    end

    context 'when player input is valid and there is a piece of his color on
    that square' do
      before do
        game.set_up_pieces
      end
      it 'returns true' do
        valid_input = 'd2'
        result = game.selection_check?(player, valid_input)
        expect(result).to be true
      end
    end
  end

  describe '#move_check?' do
    position_to_select = 'c2'
    let(:player) { double('player', color: 'white') }
    let(:selected_sqr) do
      squares.find { |sqr| sqr.position == position_to_select }
    end
    before do
      game.set_up_pieces
      game.instance_variable_set(:@selected_square, selected_sqr)
      allow(selected_sqr.occupant).to(
        receive(:valid_moves).with(board).and_return(%w[c3 c4 d5])
      )
    end

    context 'when player input is invalid' do
      it 'outputs invalid target warn and returns false' do
        warn = 'invalid target'
        expect(game).to receive(:puts).with(warn).once
        invalid_input = 'check'
        result = game.move_check?(player, invalid_input)
        expect(result).to be false
      end
    end

    context "when player input is valid and it's valid move for that
    piece" do
      it 'returns true' do
        valid_move = 'c3'
        result = game.move_check?(player, valid_move)
        expect(result).to be true
      end
    end

    context 'when player input is another valid move for that piece' do
      it 'returns true' do
        valid_move = 'd5'
        result = game.move_check?(player, valid_move)
        expect(result).to be true
      end
    end

    context 'when player input is valid but it is not a valid move for that
    piece' do
      it 'outputs invalid move warn and returns false' do
        warn = 'invalid move'
        invalid_move = 'f1'
        expect(game).to receive(:puts).with(warn).once
        result = game.move_check?(player, invalid_move)
        expect(result).to be false
      end
    end
  end

  describe '#check?' do
    let(:king) { King.new('white') }
    before { board.add_piece(king, 'c5') }
    context 'when the king is safe' do
      it 'returns false' do
        result = game.check?('white')

        expect(result).to be false
      end
    end

    context 'when the king is threatened' do
      context 'by one piece' do
        it 'returns true' do
          board.add_piece(Queen.new('black'), 'c3')

          result = game.check?('white')

          expect(result).to be true
        end
      end

      context 'by several pieces' do
        it 'returns true' do
          board.add_piece(Queen.new('black'), 'c3')
          board.add_piece(Knight.new('black'), 'd3')
          board.add_piece(Tower.new('black'), 'h5')

          result = game.check?('white')

          expect(result).to be true
        end
      end
    end
  end

  describe '#checkmate?' do
    let(:king) { King.new('white') }
    context 'when the king is in check, but can move out of it' do
      it 'returns false' do
        board.add_piece(king, 'c5')
        board.add_piece(Tower.new('black'), 'c2')

        result = game.checkmate?('white')

        expect(result).to be false
      end
    end

    context 'when the king is in check, and cannot move out of it' do
      it 'returns true' do
        board.add_piece(king, 'c5')
        board.add_piece(Tower.new('black'), 'b8')
        board.add_piece(Tower.new('black'), 'c2')
        board.add_piece(Tower.new('black'), 'd7')

        result = game.checkmate?('white')

        expect(result).to be true
      end
    end

    context 'when the king is in check but can be protected by another piece' do
      it 'returns false' do
        board.add_piece(king, 'c5')
        board.add_piece(Tower.new('white'), 'b4')
        board.add_piece(Tower.new('black'), 'c2')

        result = game.checkmate?('white')

        expect(result).to be false
      end
    end
  end

  describe '#check_avoidable_by?' do
    context 'when the piece has some move that ends check, avoiding a checkmate' do
      context 'when king can move out of threatened squares' do
        let(:king) { King.new('white') }
        let(:enemy_tower) { Tower.new('black') }
        before do
          board.add_piece(king, 'c5')
          board.add_piece(enemy_tower, 'c2')
        end
        it 'returns true' do
          result = game.check_avoidable_by?(king)

          expect(result).to be true
        end
      end

      context 'when king can capture the threatening piece' do
        let(:king) { King.new('white') }
        let(:enemy_tower) { Tower.new('black') }
        before do
          board.add_piece(king, 'c5')
          board.add_piece(enemy_tower, 'c4')
        end
        it 'returns true' do
          result = game.check_avoidable_by?(king)

          expect(result).to be true
        end
      end

      context 'when an allied piece can block the threatening piece(s)' do
        let(:king) { King.new('white') }
        let(:allied_tower) { Tower.new('white') }
        let(:enemy_tower) { Tower.new('black') }
        before do
          board.add_piece(king, 'c5')
          board.add_piece(allied_tower, 'a3')
          board.add_piece(enemy_tower, 'c1')
        end
        it 'returns true' do
          result = game.check_avoidable_by?(allied_tower)

          expect(result).to be true
        end
      end

      context 'when an allied piece can capture the threatening piece' do
        let(:king) { King.new('white') }
        let(:allied_tower) { Tower.new('white') }
        let(:enemy_tower) { Tower.new('black') }
        before do
          board.add_piece(king, 'c5')
          board.add_piece(allied_tower, 'a1')
          board.add_piece(enemy_tower, 'c1')
        end
        it 'returns true' do
          result = game.check_avoidable_by?(allied_tower)

          expect(result).to be true
        end
      end
    end

    context 'when the piece has no move that ends check' do
      context 'when king cannot move out of threatened squares' do
        let(:king) { King.new('white') }
        let(:enemy_tower1) { Tower.new('black') }
        let(:enemy_tower2) { Tower.new('black') }
        let(:enemy_tower3) { Tower.new('black') }
        before do
          board.add_piece(king, 'c5')
          board.add_piece(enemy_tower1, 'b2')
          board.add_piece(enemy_tower2, 'c2')
          board.add_piece(enemy_tower3, 'd2')
        end
        it 'returns false' do
          result = game.check_avoidable_by?(king)

          expect(result).to be false
        end
      end

      context 'when an allied piece cannot protect the king' do
        let(:king) { King.new('white') }
        let(:allied_tower) { Tower.new('white') }
        let(:enemy_tower) { Tower.new('black') }
        before do
          board.add_piece(king, 'c5')
          board.add_piece(allied_tower, 'a8')
          board.add_piece(enemy_tower, 'c1')
        end
        it 'returns false' do
          result = game.check_avoidable_by?(allied_tower)

          expect(result).to be false
        end
      end
    end

    context 'when the method moves the piece to test if it can end the check' do
      let(:king) { King.new('white') }
      let(:allied_tower) { Tower.new('white') }
      let(:enemy_tower) { Tower.new('black') }
      before do
        board.add_piece(king, 'c5')
        board.add_piece(allied_tower, 'h1')
        board.add_piece(enemy_tower, 'c1')
      end
      it "the squares the piece moved into keep it's original occupant after that" do
        c1 = board.find_square('c1')

        expect { game.check_avoidable_by?(allied_tower) }
          .not_to(change { c1.occupant })
      end
    end
  end

  describe '#exposing_move?' do
    let(:king_w) { King.new('white') }
    let(:tower_w) { Tower.new('white') }
    let(:tower_b) { Tower.new('black') }
    let(:player_w) { double('player', color: 'white') } 
    context 'when the tower move will not expose the king to a check' do
      it 'returns false' do
        board.add_piece(king_w, 'a1')
        board.add_piece(tower_w, 'c1')
        board.add_piece(tower_b, 'h1')
        game.select_square('c1')
        move = 'e1'
        move_square = board.find_square(move)

        result = game.exposing_move?(player_w, move_square)

        expect(result).to be false
      end
    end

    context 'when the tower move will expose the king to a check' do
      it 'returns true' do
        board.add_piece(king_w, 'a1')
        board.add_piece(tower_w, 'c1')
        board.add_piece(tower_b, 'h1')
        game.select_square('c1')
        move = 'c8'
        move_square = board.find_square(move)

        result = game.exposing_move?(player_w, move_square)

        expect(result).to be true
      end
    end

    context 'when moving the piece only to find out if the move will expose the
    king to a check' do
      it 'the original occupant of each square remain after the testing move' do
        board.add_piece(king_w, 'e1')
        board.add_piece(tower_w, 'f5')
        board.add_piece(tower_b, 'f2')
        game.select_square('f5')
        move = 'f2'
        f2 = board.find_square(move)

        expect { game.exposing_move?(player_w, f2) }
          .not_to (change { f2.occupant })
      end
    end
  end
end
