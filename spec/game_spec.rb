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
        board.set_up_pieces
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
        board.set_up_pieces
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
        board.set_up_pieces
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
    let(:player) { double('player') }
    let(:selected_sqr) do
      squares.find { |sqr| sqr.position == position_to_select }
    end
    before do
      board.set_up_pieces
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
end
