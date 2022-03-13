# frozen_string_literal: true

require_relative '../lib/pieces/tower'
require_relative '../lib/board'

describe Tower do
  subject(:tower) { described_class.new('white') }
  let(:board) { Board.new }

  describe '#horizontal' do
    context 'when the tower is unobstructed' do
      context 'when it is at the center of the board' do
        before do
          board.add_piece(tower, 'c3')
        end
        it "returns an array with all squares of it's row except it's own" do
          row_array = %w[a3 b3 d3 e3 f3 g3 h3]

          result = tower.horizontal(board)

          expect(result).to match_array(row_array)
        end
      end

      context 'when it at the end of the board' do
        before do
          board.add_piece(tower, 'a1')
        end
        it "returns an array with all squares of it's row except it's own" do
          row_array = %w[c1 b1 d1 e1 f1 g1 h1]

          result = tower.horizontal(board)

          expect(result).to match_array(row_array)
        end
      end
    end

    context 'when the tower is obstructed' do
      before do
        board.add_piece(tower, 'g2')
      end
      context "when it's a same color piece" do
        let(:obstructing_white) { double('piece', color: 'white') }
        it 'stops the line at the obstruction position not including it' do
          column_array = %w[h2 d2 e2 f2]
          board.add_piece(obstructing_white, 'c2')

          result = tower.horizontal(board)

          expect(result).to match_array(column_array)
        end
      end
      context "when it's an opposite color piece" do
        let(:obstructing_black) { double('piece', color: 'black') }
        it 'stops the line at the obstruction position including it' do
          column_array = %w[h2 d2 e2 f2 c2]
          board.add_piece(obstructing_black, 'c2')

          result = tower.horizontal(board)

          expect(result).to match_array(column_array)
        end
      end
    end
  end

  describe '#vertical' do
    context 'when the tower is unobstructed' do
      context 'when it is at the center of the board' do
        before do
          board.add_piece(tower, 'c3')
        end
        it "returns an array with all squares of it's column except it's own" do
          column_array = %w[c4 c5 c6 c7 c8 c2 c1]
          result = tower.vertical(board)

          expect(result).to match_array(column_array)
        end
      end
    end
  end
end
