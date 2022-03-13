# frozen_string_literal: true

require_relative '../lib/pieces/king'
require_relative '../lib/board'

describe King do
  subject(:king) { described_class.new('white') }
  let(:board) { Board.new }

  describe '#adjacent_coordinates' do
    context 'when king is at the center of the board' do
      it 'returns an array with all 8 valid moves positions' do
        board.add_piece(king, 'd4')
        adjacent_positions = %w[d5 d3 c4 e4 c5 e5 c3 e3]

        result = king.adjacent_positions(board)

        expect(result).to match_array(adjacent_positions)
      end
    end

    context 'when king is at the edge of the board' do
      it 'returns an array with only the valid moves positions' do
        board.add_piece(king, 'a1')
        adjacent_positions = %w[a2 b1 b2]

        result = king.adjacent_positions(board)

        expect(result).to match_array(adjacent_positions)
      end
    end
  end

  describe '#valid_moves' do
    before do
      board.add_piece(king, 'f2')
    end
    context 'when there is no piece adjacent to king' do
      it 'returns an array with all 8 valid moves positions' do
        adjacent_positions = %w[e1 f1 g1 e3 f3 g3 e2 g2]

        result = king.valid_moves(board)

        expect(result).to match_array(adjacent_positions)
      end
    end

    context 'when there are pieces adjacent to king' do
      let(:opposite_color_piece) { double('piece', color: 'black') }
      context 'when it is a same color piece' do
        let(:same_color_piece) { double('piece', color: 'white') }
        it "doesn't include that piece's position on the valid moves
        array" do
          board.add_piece(same_color_piece, 'e3')
          adjacent_positions = %w[e1 f1 g1 f3 g3 e2 g2]
  
          result = king.valid_moves(board)
  
          expect(result).to match_array(adjacent_positions)
        end
      end
      context 'when it is an opposite color piece' do
        let(:opposite_color_piece) { double('piece', color: 'black') }
        it "includes that piece'position on the valid moves array" do
          board.add_piece(opposite_color_piece, 'e3')
          adjacent_positions = %w[e1 f1 g1 e3 f3 g3 e2 g2]
  
          result = king.valid_moves(board)
  
          expect(result).to match_array(adjacent_positions)
        end
      end
    end
  end
end