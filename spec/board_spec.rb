# frozen_string_literal: true

require_relative '../lib/board'

describe Board do
  subject(:board) { described_class.new }

  describe '#initialize' do
    matcher :be_8x8_array do
      match do |array|
        array.all? do |row_array|
          row_array.length == 8
        end && array.length == 8
      end
    end
    it 'set @grid to an array with 8 arrays, each of with 8 elements' do
      expect(board.grid).to be_8x8_array
    end
    it "set each square's @position to correspond their grid's position" do
      a1_sqr = board.grid.dig(7, 0)
      a8_sqr = board.grid.dig(0, 0)
      h1_sqr = board.grid.dig(7, 7)
      h8_sqr = board.grid.dig(0, 7)
      f5_sqr = board.grid.dig(3, 5)
      d2_sqr = board.grid.dig(6, 3)
      expect(a1_sqr.position).to eq 'a1'
      expect(a8_sqr.position).to eq 'a8'
      expect(h1_sqr.position).to eq 'h1'
      expect(h8_sqr.position).to eq 'h8'
      expect(f5_sqr.position).to eq 'f5'
      expect(d2_sqr.position).to eq 'd2'
    end
  end

  describe '#show' do
    before do
      allow(board).to receive(:black_square).and_return('black')
      allow(board).to receive(:blue_square).and_return('blue')
    end
    it 'outputs the board grid' do
      board_grid = <<~LITERAL_GRID
        blackblueblackblueblackblueblackblue
        blueblackblueblackblueblackblueblack
        blackblueblackblueblackblueblackblue
        blueblackblueblackblueblackblueblack
        blackblueblackblueblackblueblackblue
        blueblackblueblackblueblackblueblack
        blackblueblackblueblackblueblackblue
        blueblackblueblackblueblackblueblack
      LITERAL_GRID
      expect { board.show }.to output(board_grid).to_stdout
    end
  end

  describe '#add_piece' do
    context "when adding piece 'king' to 'e7'" do
      it "assigns 'king' as occupant of square 'e7'" do
        board.add_piece('king', 'e7')
        e7_occupant = board.grid.dig(1, 4).occupant
        expect(e7_occupant).to eq 'king'
      end
    end
  end
end
