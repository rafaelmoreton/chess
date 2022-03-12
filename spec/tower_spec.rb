# frozen_string_literal: true

require_relative '../lib/pieces/tower'

describe Tower do
  subject(:tower) { described_class.new }
  sqr_symbols = [
    :a5, :b5, :c5, :d5, :e5,
    :a4, :b4, :c4, :d4, :e4,
    :a3, :b3, :c3, :d3, :e3,
    :a2, :b2, :c2, :d2, :e2,
    :a1, :b1, :c1, :d1, :e1
  ]
  sqr_symbols.each do |symbol|
    let(symbol) { double('square', position: symbol.to_s, occupant: nil) }
  end
  let(:board) { double('board', grid: [
                                  a5, b5, c5, d5, e5,
                                  a4, b4, c4, d4, e4,
                                  a3, b3, c3, d3, e3,
                                  a2, b2, c2, d2, e2,
                                  a1, b1, c1, d1, e1
                                ]) }
  
  describe '#horizontal' do
    context 'when the tower is unobstructed' do
      context 'when it is at the center of the board' do
        before do
          allow(c3).to receive(:occupant).and_return(tower)
        end
        it "returns an array with all squares of it's row, except it's own" do
          row_array = %w[a3 b3 d3 e3]
          result = tower.horizontal

          expect(result).to match_array(row_array)
        end
      end
    end
  end
end