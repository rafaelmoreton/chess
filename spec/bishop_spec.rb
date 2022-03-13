# frozen_string_literal: true

require_relative '../lib/pieces/bishop'
require_relative '../lib/board'

describe Bishop do
  subject(:bishop) { described_class.new('white') }
  let(:board) { Board.new }

  describe '#up' do
    context 'when the bishop is unobstructed' do
      context 'when it is at the center of the board' do
        before do
          board.add_piece(bishop, 'c3')
        end
        it "returns an array with all squares of it's up diagonals except it's
        own" do
          up_diagonals = %w[d4 e5 f6 g7 h8 b4 a5]

          result = bishop.up(board)

          expect(result).to match_array(up_diagonals)
        end
      end

      context 'when it at the end of the board' do
        before do
          board.add_piece(bishop, 'a1')
        end
        it "returns an array with all squares of it's up diagonals except it's
        own" do
          up_diagonals = %w[b2 c3 d4 e5 f6 g7 h8]

          result = bishop.up(board)

          expect(result).to match_array(up_diagonals)
        end
      end
    end

    context 'when the bishop is obstructed' do
      before do
        board.add_piece(bishop, 'g4')
      end
      context "when it's a same color piece" do
        let(:obstructing_white) { double('piece', color: 'white') }
        it 'stops the line at the obstruction position not including it' do
          obstructed_diagonals = %w[h5 f5 e6]
          board.add_piece(obstructing_white, 'd7')

          result = bishop.up(board)

          expect(result).to match_array(obstructed_diagonals)
        end
      end
      context "when it's an opposite color piece" do
        let(:obstructing_black) { double('piece', color: 'black') }
        it 'stops the line at the obstruction position including it' do
          obstructed_diagonals = %w[h5 f5 e6 d7]
          board.add_piece(obstructing_black, 'd7')

          result = bishop.up(board)

          expect(result).to match_array(obstructed_diagonals)
        end
      end
    end
  end

  describe '#down' do
    context 'when the bishop is unobstructed' do
      context 'when it is at the center of the board' do
        before do
          board.add_piece(bishop, 'c4')
        end
        it "returns an array with all squares of it's down diagonals except
        it's own" do
          down_diagonals = %w[b3 a2 d3 e2 f1]
          result = bishop.down(board)

          expect(result).to match_array(down_diagonals)
        end
      end
    end
  end
end
