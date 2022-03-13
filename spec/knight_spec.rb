# frozen_string_literal: true

require_relative '../lib/pieces/knight'
require_relative '../lib/board'

describe Knight do
  subject(:knight) { described_class.new('white') }
  let(:board) { Board.new }

  describe '#valid_moves' do
    context 'when knight is at the center of the board' do
      before do
        board.add_piece(knight, 'd4')
      end
      it 'returns an array with all 8 valid moves' do
        valid_moves = %w[e6 c6 e2 c2 b5 b3 f5 f3]

        result = knight.valid_moves(board)

        expect(result).to match_array(valid_moves)
      end
    end

    context 'when knight is at the edge of the board' do
      before do
        board.add_piece(knight, 'a1')
      end
      it 'returns an array with only the valid moves positions' do
        valid_moves = %w[b3 c2]

        result = knight.valid_moves(board)

        expect(result).to match_array(valid_moves)
      end
    end

    context 'when there is are pieces on squares accessible to knight' do
      before do
        board.add_piece(knight, 'a5')
      end
      context 'when it is a same color piece' do
        let(:same_color_piece) { double('piece', color: 'white') }
        it 'returns an array with only the valid moves positions, not including
        that piece position' do
          board.add_piece(same_color_piece, 'b7')
          valid_moves = %w[b3 c4 c6]

          result = knight.valid_moves(board)

          expect(result).to match_array(valid_moves)
        end
      end

      context 'when it is an opposite color piece' do
        let(:opposite_color_piece) { double('piece', color: 'black') }
        it 'returns an array with only the valid moves positions, including
        that piece position' do
          board.add_piece(opposite_color_piece, 'b7')
          valid_moves = %w[b3 c4 b7 c6]

          result = knight.valid_moves(board)

          expect(result).to match_array(valid_moves)
        end
      end
    end
  end
end