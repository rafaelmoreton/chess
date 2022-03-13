# frozen_string_literal: true

require_relative '../lib/pieces/piece'

describe Piece do
  subject(:piece) { described_class.new('white') }
  sqr_symbols = %i[
    a8 b8 c8 d8 e8 f8 g8 h8
    a7 b7 c7 d7 e7 f7 g7 h7
    a6 b6 c6 d6 e6 f6 g6 h6
    a5 b5 c5 d5 e5 f5 g5 h5
    a4 b4 c4 d4 e4 f4 g4 h4
    a3 b3 c3 d3 e3 f3 g3 h3
    a2 b2 c2 d2 e2 f2 g2 h2
    a1 b1 c1 d1 e1 f1 g1 h1
  ]
  sqr_symbols.each do |symbol|
    let(symbol) { double('square', position: symbol.to_s, occupant: nil) }
  end
  let(:board) do
    double(
      'board',
      grid:
        [
          [a8, b8, c8, d8, e8, f8, g8, h8],
          [a7, b7, c7, d7, e7, f7, g7, h7],
          [a6, b6, c6, d6, e6, f6, g6, h6],
          [a5, b5, c5, d5, e5, f5, g5, h5],
          [a4, b4, c4, d4, e4, f4, g4, h4],
          [a3, b3, c3, d3, e3, f3, g3, h3],
          [a2, b2, c2, d2, e2, f2, g2, h2],
          [a1, b1, c1, d1, e1, f1, g1, h1]
        ]
    )
  end

  describe '#find_coordinates' do
    it 'returns a hash containing the coordinates this piece occupies' do
      allow(a3).to receive(:occupant).and_return(piece)
      occupied_square_coordinates = { column: 'a', row: '3' }

      piece_sqr = piece.find_coordinates(board)

      expect(piece_sqr).to eq occupied_square_coordinates
    end
  end

  describe '#shift_coordinates' do
    context 'when called with a coordinates hash and shifting values' do
      it 'returns a similar hash, shifted according to the shifting values' do
        coord = { column: 'a', row: '3' }
        shifted_coord = { column: 'a', row: '4' }
        column_shift = 0
        row_shift = 1

        result = piece.shift_coordinates(coord, column_shift, row_shift)

        expect(result).to eq shifted_coord
      end
    end

    context 'when called with other hash and shifting values' do
      it 'returns a similar hash, shifted according to the shifting values' do
        coord = { column: 'a', row: '3' }
        shifted_coord = { column: 'c', row: '5' }
        column_shift = 2
        row_shift = 2

        result = piece.shift_coordinates(coord, column_shift, row_shift)

        expect(result).to eq shifted_coord
      end
    end

    context 'when called with negative hash coords and shifting values' do
      it 'returns a similar hash, shifted according to the shifting values' do
        coord = { column: 'c', row: '3' }
        shifted_coord = { column: 'b', row: '1' }
        column_shift = -1
        row_shift = -2

        result = piece.shift_coordinates(coord, column_shift, row_shift)

        expect(result).to eq shifted_coord
      end
    end

    context "when the shifted coordinates aren't valid board positions" do
      it "returns 'nil'" do
        coord = { column: 'a', row: '1' }
        column_shift = 0
        row_shift = -1

        result = piece.shift_coordinates(coord, column_shift, row_shift)

        expect(result).to be nil
      end
    end
  end

  describe '#find_direction_coordinates' do
    context 'when passed values for right direction (1, 0)' do
      it 'returns an array containing the all valid coordinates to the right' do
        allow(c3).to receive(:occupant).and_return(piece)
        allow(board).to receive(:find_square).and_return(
          d3, e3, f3, g3, h3, nil
        )
        right_coordinates = %w[d3 e3 f3 g3 h3]
        right_dir = [1, 0]

        result = piece.find_direction_coordinates(right_dir, board)

        expect(result).to match_array(right_coordinates)
      end
    end

    context 'when passed values for down direction (0, -1)' do
      it 'returns an array containing the all valid coordinates to down' do
        allow(c3).to receive(:occupant).and_return(piece)
        allow(board).to receive(:find_square).and_return(c2, c1, nil)
        down_coordinates = %w[c2 c1]
        down_dir = [0, -1]

        result = piece.find_direction_coordinates(down_dir, board)

        expect(result).to match_array(down_coordinates)
      end
    end

    context 'when passed values for down right direction (1, -1)' do
      it 'returns an array containing the all valid coordinates to down_r' do
        allow(c4).to receive(:occupant).and_return(piece)
        allow(board).to receive(:find_square).and_return(d3, e2, f1, nil)
        down_r_coordinates = %w[d3 e2 f1]
        down_r_dir = [1, -1]

        result = piece.find_direction_coordinates(down_r_dir, board)

        expect(result).to match_array(down_r_coordinates)
      end
    end
  end
end
