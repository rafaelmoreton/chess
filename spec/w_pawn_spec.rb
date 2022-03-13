# frozen_string_literal: true

require_relative '../lib/pieces/w_pawn'

describe WPawn do
  subject(:white_pawn) { described_class.new('white') }
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

  describe '#valid_ahead' do
    context 'when there is no piece ahead of the pawn' do
      before do
        allow(b1).to receive(:occupant).and_return(white_pawn)
        allow(small_board).to receive(:find_square).and_return(b2)
      end
      it 'returns the square ahead in an array' do
        valid_ahead = white_pawn.valid_ahead(small_board)
        expect(valid_ahead).to eq ['b2']
      end
    end

    context 'when there is a same color piece ahead of the pawn' do
      let(:ahead_white_pawn) { double('piece', color: 'white') }
      before do
        allow(b1).to receive(:occupant).and_return(white_pawn)
        allow(b2).to receive(:occupant).and_return(:ahead_white_pawn)
        allow(small_board).to receive(:find_square).and_return(b2)
      end
      it 'returns an empty array' do
        valid_ahead = white_pawn.valid_ahead(small_board)
        expect(valid_ahead).to eq []
      end
    end

    context 'when there is an opposite color piece ahead of the pawn' do
      let(:ahead_black_pawn) { double('piece', color: 'black') }
      before do
        allow(b1).to receive(:occupant).and_return(white_pawn)
        allow(b2).to receive(:occupant).and_return(:ahead_black_pawn)
        allow(small_board).to receive(:find_square).and_return(b2)
      end
      it 'returns an empty array' do
        valid_ahead = white_pawn.valid_ahead(small_board)
        expect(valid_ahead).to eq []
      end
    end
  end

  describe '#valid_start_jump' do
    before do
      allow(b1).to receive(:occupant).and_return(white_pawn)
      allow(small_board).to receive(:find_square).and_return(b2, b3)
    end

    context 'when pawn is not at start position' do
      before do
        white_pawn.start_position = false
      end
      it 'returns an empty array' do
        valid_jump = white_pawn.valid_start_jump(small_board)
        expect(valid_jump).to eq []
      end
    end

    context 'when pawn is at start position' do
      context 'when there is no piece on the two squares ahead' do
        it 'returns the second square ahead in an array' do
          valid_jump = white_pawn.valid_start_jump(small_board)
          expect(valid_jump).to eq ['b3']
        end
      end

      context 'when there is a piece on the first square ahead' do
        let(:ahead_white_pawn) { double('piece', color: 'white') }
        before do
          allow(b2).to receive(:occupant).and_return(ahead_white_pawn)
        end
        it 'returns an empty array' do
          valid_jump = white_pawn.valid_start_jump(small_board)
          expect(valid_jump).to eq []
        end
      end

      context 'when there is a piece on the second square ahead' do
        let(:jump_white_pawn) { double('piece', color: 'white') }
        before do
          allow(b3).to receive(:occupant).and_return(jump_white_pawn)
        end
        it 'returns an empty array' do
          valid_jump = white_pawn.valid_start_jump(small_board)
          expect(valid_jump).to eq []
        end
      end

      context 'when the piece on second square ahead is of opposite color' do
        let(:jump_black_pawn) { double('piece', color: 'black') }
        before do
          allow(b3).to receive(:occupant).and_return(jump_black_pawn)
        end
        it 'returns an empty array' do
          valid_jump = white_pawn.valid_start_jump(small_board)
          expect(valid_jump).to eq []
        end
      end
    end
  end

  describe '#valid_diagonal' do
    context 'when direction is left and pawn is at left edge of board' do
      before do
        allow(a1).to receive(:occupant).and_return(white_pawn)
        allow(small_board).to receive(:find_square)
      end
      it 'returns an empty array' do
        result = white_pawn.valid_diagonal(small_board, 'left')

        expect(result).to eq []
      end
    end

    context 'when there is no piece at the diagonal' do
      before do
        allow(b1).to receive(:occupant).and_return(white_pawn)
        allow(small_board).to receive(:find_square).and_return(a2)
      end
      it 'returns an empty array' do
        valid_diagonal = white_pawn.valid_diagonal(small_board, 'left')
        expect(valid_diagonal).to eq []
      end
    end

    context 'when there are pieces at diagonals' do
      let(:diag_white_pawn) { double('piece', color: 'white') }
      let(:diag_black_pawn) { double('piece', color: 'black') }
      before do
        allow(b1).to receive(:occupant).and_return(white_pawn)
        allow(a2).to receive(:occupant).and_return(diag_white_pawn)
        allow(c2).to receive(:occupant).and_return(diag_black_pawn)
      end
      context 'when it is a same color piece' do
        it 'returns an empty array' do
          allow(small_board).to receive(:find_square).and_return(a2)
          valid_diagonal = white_pawn.valid_diagonal(small_board, 'left')
          expect(valid_diagonal).to eq []
        end
      end
      context 'when it is an opposite color piece' do
        it 'retuns diagonal square in an array' do
          allow(small_board).to receive(:find_square).and_return(c2)
          valid_diagonal = white_pawn.valid_diagonal(small_board, 'right')
          expect(valid_diagonal).to eq ['c2']
        end
      end
    end
  end

  # describe '#valid_moves' do
  #   context 'when a pawn is unobstructed' do
  #     before do
  #       allow(b1).to receive(:occupant).and_return(white_pawn)
  #     end

  #     it 'includes the square in front of in valid moves' do
  #       valid_moves = white_pawn.valid_moves(small_board)
  #       expect(valid_moves).to include b2.position
  #     end

  #     context "and if the pawn is at it's starting position" do
  #       it 'includes the second square in front of it in valid moves' do
  #         valid_moves = white_pawn.valid_moves(small_board)
  #         expect(valid_moves).to include b3.position
  #       end
  #     end
  #     context "but if the pawn is not at it's starting position" do
  #      it "doesn't include the second square in front of it in valid moves" do
  #         white_pawn.instance_variable_set(:@start_position, false)

  #         valid_moves = white_pawn.valid_moves(small_board)
  #         expect(valid_moves).not_to include b3.position
  #       end
  #     end
  #   end

  #   context 'when a pawn is obstructed by a same color piece' do
  #     let(:obs_white_pawn) { double('piece', color: 'white') }
  #     before do
  #       allow(b1).to receive(:occupant).and_return(white_pawn)
  #       allow(b2).to receive(:occupant).and_return(obs_white_pawn)
  #     end
  #     it 'does not include the squares in front of it in valid moves' do
  #       valid_moves = white_pawn.valid_moves(small_board)
  #       expect(valid_moves).not_to include(b2.position, b3.position)
  #     end
  #   end

  #   context 'when a pawn is obstructed by an opposite color piece' do
  #     let(:obs_black_pawn) { double('piece', color: 'black') }
  #     before do
  #       allow(b1).to receive(:occupant).and_return(white_pawn)
  #       allow(b2).to receive(:occupant).and_return(obs_black_pawn)
  #     end
  #     it 'does not include the squares in front of it in valid moves' do
  #       valid_moves = white_pawn.valid_moves(small_board)
  #       expect(valid_moves).not_to include(b2.position, b3.position)
  #     end
  #   end

  #   context 'when there is no piece at diagonals' do
  #     before do
  #       allow(b1).to receive(:occupant).and_return(white_pawn)
  #     end
  #     xit 'does not include neither diagonal in valid moves' do
  #       valid_moves = white_pawn.valid_moves(small_board)
  #       expect(valid_moves).not_to include(a2.position, c2.position)
  #     end
  #   end

  #   context 'when there are pieces at diagonals' do
  #     let(:diag_white_pawn) { double('piece', color: 'white') }
  #     let(:diag_black_pawn) { double('piece', color: 'black') }
  #     before do
  #       allow(b1).to receive(:occupant).and_return(white_pawn)
  #       allow(a2).to receive(:occupant).and_return(diag_white_pawn)
  #       allow(c2).to receive(:occupant).and_return(diag_black_pawn)
  #     end
  #     xit 'does not include the same color piece diagonal in valid moves' do
  #       valid_moves = white_pawn.valid_moves(small_board)
  #       expect(valid_moves).not_to include a2.position
  #     end
  #     xit 'includes the opposite color piece diagonal in valid moves' do
  #       valid_moves = white_pawn.valid_moves(small_board)
  #       expect(valid_moves).to include c2.position
  #     end
  #   end
  # end
end
