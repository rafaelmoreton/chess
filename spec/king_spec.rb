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

  describe '#find_towers' do
    let(:allied_tower_a) { Tower.new('white') }
    let(:allied_tower_b) { Tower.new('white') }
    context 'when there are allied towers in their starting positions' do
      before do
        board.add_piece(allied_tower_a, 'a1')
        board.add_piece(allied_tower_b, 'h1')
      end
      it 'returns an array containing the towers' do
        towers_array = [allied_tower_a, allied_tower_b]

        result = king.find_towers(board)

        expect(result).to match_array(towers_array)
      end
    end

    context 'when there are allied towers, but they are not in their starting
    positions' do
      before do
        allied_tower_a.start_position = false
        allied_tower_b.start_position = false
        board.add_piece(allied_tower_a, 'a1')
        board.add_piece(allied_tower_b, 'h1')
      end
      it 'returns an empty array' do
        result = king.find_towers(board)

        expect(result).to match_array([])
      end
    end

    context 'when there is no allied tower' do
      it 'returns an empty array' do
        result = king.find_towers(board)

        expect(result).to match_array([])
      end
    end
  end

  describe '#castling_moves' do
    before { board.add_piece(king, 'e1') }
    context 'when there is no tower available to castle' do
      it 'returns an empty array' do
        result = king.castling_moves(board)

        expect(result).to match_array([])
      end
    end

    context 'when there are allied towers in starting position, but they are
    obstructed by some other piece' do
      let(:allied_tower_a) { Tower.new('white') }
      let(:allied_tower_b) { Tower.new('white') }
      let(:obstructing_a) { double('piece', color: 'white') }
      let(:obstructing_b) { double('piece', color: 'white') }
      before do
        board.add_piece(allied_tower_a, 'a1')
        board.add_piece(allied_tower_b, 'h1')
        board.add_piece(obstructing_a, 'c1')
        board.add_piece(obstructing_b, 'g1')
      end
      it 'returns an empty array' do
        result = king.castling_moves(board)

        expect(result).to match_array([])
      end
    end

    context 'when there are allied towers able to castle' do
      let(:allied_tower_a) { Tower.new('white') }
      let(:allied_tower_b) { Tower.new('white') }
      before do
        board.add_piece(allied_tower_a, 'a1')
        board.add_piece(allied_tower_b, 'h1')
      end
      it 'returns an array containing the move position for the king for each
      possible case' do
        king_castling_moves = %w[g1 c1]

        result = king.castling_moves(board)

        expect(result).to match_array(king_castling_moves)
      end
    end

    context 'when there are allied towers able to castle, but king is not at
    starting position' do
      let(:allied_tower_a) { Tower.new('white') }
      let(:allied_tower_b) { Tower.new('white') }
      before do
        board.add_piece(allied_tower_a, 'a1')
        board.add_piece(allied_tower_b, 'h1')
        king.start_position = false
      end
      it 'returns an empty array' do
        result = king.castling_moves(board)

        expect(result).to match_array([])
      end
    end
  end

  describe '#castle' do
    let(:castling_tower) { Tower.new('white') }
    before do
      board.add_piece(king, 'e1')
      board.add_piece(castling_tower, 'a1')
    end
    it 'moves the tower to which the king is castling to the square leaped by
    the king' do
      king_move = 'c1'
      leaped_sqr = board.square('d1')
      tower_sqr = board.square('a1')

      expect { king.castle(board, king_move) }.to(
        change { leaped_sqr.occupant }.to(castling_tower) &
        change { tower_sqr.occupant }.to(nil)
      )
    end
  end
end
