# frozen_string_literal: true

require_relative '../lib/piece'

describe Piece do
  subject(:piece) { described_class.new('white') }
  let(:a3) { double('square', position: 'a3', occupant: nil) }
  let(:b3) { double('square', position: 'b3', occupant: nil) }
  let(:c3) { double('square', position: 'c3', occupant: nil) }
  let(:a2) { double('square', position: 'a2', occupant: nil) }
  let(:b2) { double('square', position: 'b2', occupant: nil) }
  let(:c2) { double('square', position: 'c2', occupant: nil) }
  let(:a1) { double('square', position: 'a1', occupant: nil) }
  let(:b1) { double('square', position: 'b1', occupant: nil) }
  let(:c1) { double('square', position: 'c1', occupant: nil) }
  let(:small_grid) { [[a3, b3, c3], [a2, b2, c2], [a1, b1, c1]] }
  let(:small_board) { double('board', grid: small_grid) }

  describe '#find_coordinates' do
    it 'returns a hash containing the coordinates this piece occupies' do
      allow(a3).to receive(:occupant).and_return(piece)
      occupied_square_coordinates = { column: 'a', row: '3' }

      piece_sqr = piece.find_coordinates(small_board)

      expect(piece_sqr).to eq occupied_square_coordinates
    end
  end
end
