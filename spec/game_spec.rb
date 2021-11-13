# frozen_string_literal: true

# rubocop:disable all

require_relative '../lib/game'
require_relative '../lib/board'
require_relative '../lib/pieces'
require_relative '../lib/square'

describe Game do
  subject(:game) { described_class.new }

  describe '#establish_players' do
    player_one = 'Matt'
    player_two = 'Gary'

    before do
      allow(game).to receive(:puts).twice
      allow(game).to receive(:gets).and_return(player_one, player_two)
    end

    it 'creates two instances of Player with user inputted names' do
      expect(Player).to receive(:new).with(player_one).once
      expect(Player).to receive(:new).with(player_two).once
      game.establish_players
    end
  end

  describe '#randomize_colors' do
    let(:player_one) { instance_double(Player, 'Matt') }
    let(:player_two) { instance_double(Player, 'Gary') }

    before do
      game.instance_variable_set(:@players, [player_one, player_two])
    end

    it 'calls color on both Player instances' do
      expect(player_one).to receive(:color=).once
      expect(player_two).to receive(:color=).once
      game.randomize_colors
    end
  end

  describe '#generate_pieces' do
    let(:player_one) { instance_double(Player, name: 'Matt', color: 'white') }
    let(:player_two) { instance_double(Player, name: 'Gary', color: 'black') }

    before do
      game.instance_variable_set(:@players, [player_one, player_two])
    end

    it 'generates 8 pawns for both players' do
      expect { game.generate_pieces(player_one) }.to change { game.board.pieces.select { |piece| piece.is_a?(Pawn) && piece.color == 'white' }.size }.from(0).to(8)
      expect { game.generate_pieces(player_two) }.to change { game.board.pieces.select { |piece| piece.is_a?(Pawn) && piece.color == 'black' }.size }.from(0).to(8)
    end

    it 'generates 2 rooks for both players' do
      expect { game.generate_pieces(player_one) }.to change { game.board.pieces.select { |piece| piece.is_a?(Rook) && piece.color == 'white' }.size }.from(0).to(2)
      expect { game.generate_pieces(player_two) }.to change { game.board.pieces.select { |piece| piece.is_a?(Rook) && piece.color == 'black' }.size }.from(0).to(2)
    end

    it 'generates 2 knights for both players' do
      expect { game.generate_pieces(player_one) }.to change { game.board.pieces.select { |piece| piece.is_a?(Bishop) && piece.color == 'white' }.size }.from(0).to(2)
      expect { game.generate_pieces(player_two) }.to change { game.board.pieces.select { |piece| piece.is_a?(Bishop) && piece.color == 'black' }.size }.from(0).to(2)
    end

    it 'generates 2 bishops for both players' do
      expect { game.generate_pieces(player_one) }.to change { game.board.pieces.select { |piece| piece.is_a?(Knight) && piece.color == 'white' }.size }.from(0).to(2)
      expect { game.generate_pieces(player_two) }.to change { game.board.pieces.select { |piece| piece.is_a?(Knight) && piece.color == 'black' }.size }.from(0).to(2)
    end

    it 'generates 1 queen for both players' do
      expect { game.generate_pieces(player_one) }.to change { game.board.pieces.select { |piece| piece.is_a?(Queen) && piece.color == 'white' }.size }.from(0).to(1)
      expect { game.generate_pieces(player_two) }.to change { game.board.pieces.select { |piece| piece.is_a?(Queen) && piece.color == 'black' }.size }.from(0).to(1)
    end

    it 'generates 1 king for both players' do
      expect { game.generate_pieces(player_one) }.to change { game.board.pieces.select { |piece| piece.is_a?(King) && piece.color == 'white' }.size }.from(0).to(1)
      expect { game.generate_pieces(player_two) }.to change { game.board.pieces.select { |piece| piece.is_a?(King) && piece.color == 'black' }.size }.from(0).to(1)
    end
  end

  describe '#promotion' do
    context 'white is promoting' do
      let(:pawn) { Pawn.new('d7', 'white') }
      let(:player) { instance_double(Player, name: 'Matt', color: 'white') }

      before do
        game.board.populate_square(pawn, 'd7')
        allow(game).to receive(:select_piece).and_return(pawn)
        allow(game).to receive(:select_move).and_return('d8')
        allow(game).to receive(:gets).and_return('queen')
      end

      it 'it promotes pawn to queen' do
        game.play_move(player)
        square = game.board.squares.select { |square| square.location == 'd8' }.pop
        expect(square.piece).to be_a(Queen)
      end
    end

    context 'black is promoting' do
      let(:pawn) { Pawn.new('d2', 'black') }
      let(:player) { instance_double(Player, name: 'Matt', color: 'black') }

      before do
        game.board.populate_square(pawn, 'd2')
        allow(game).to receive(:select_piece).and_return(pawn)
        allow(game).to receive(:select_move).and_return('d1')
        allow(game).to receive(:gets).and_return('knight')
      end

      it 'it promotes pawn to knight' do
        game.play_move(player)
        square = game.board.squares.select { |square| square.location == 'd1' }.pop
        expect(square.piece).to be_a(Knight)
      end
    end
  end
end

describe Pawn do
  context 'when the pawn is white' do
    subject(:pawn) { described_class.new('e2', 'white') }
    let(:board) { Board.new }

    describe '#legal_moves' do
      context 'when pawn location is on start location e2 and no captures are available' do
        it 'creates [e3, e4]' do
          expect(pawn.add_moves(board)).to eq(['e3', 'e4'])
        end
      end

      context 'when pawn location is on start location e2 and with two captures available' do
        before do
          board.populate_square(Pawn.new('d3', 'black'), 'd3')
          board.populate_square(Pawn.new('f3', 'black'), 'f3')
        end
        
        it 'creates [e3, e4, d3, f3]' do
          expect(pawn.add_moves(board)).to eq(['e3', 'e4', 'd3', 'f3'])
        end
      end

      context 'when pawn location is not on start location and no captures are available' do
        subject(:pawn) { described_class.new('e3', 'white') }

        it 'creates [e4]' do
          expect(pawn.add_moves(board)).to eq(['e4'])
        end
      end

      context 'when pawn is blocked and no captures are available' do
        subject(:pawn) { described_class.new('e3', 'white') }

        before do
          board.populate_square(Pawn.new('e4', 'black'), 'e4')
        end

        it 'creates []' do
          expect(pawn.add_moves(board)).to eq([])
        end
      end
    end
  end

  context 'when the pawn is black' do
    subject(:pawn) { described_class.new('e7', 'black') }
    let(:board) { Board.new }

    describe '#legal_moves' do
      context 'when pawn location is on start location e7 and no captures are available' do
        it 'creates [e6, e5]' do
          expect(pawn.add_moves(board)).to eq(['e6', 'e5'])
        end
      end

      context 'when pawn location is on start location e2 and with two captures available' do
        before do
          board.populate_square(Pawn.new('d6', 'white'), 'd6')
          board.populate_square(Pawn.new('f6', 'white'), 'f6')
        end
        
        it 'creates [e6, e5, d6, f6]' do
          expect(pawn.add_moves(board)).to eq(%w[e6 e5 d6 f6])
        end
      end

      context 'when pawn location is not on start location and no captures are available' do
        subject(:pawn) { described_class.new('e6', 'black') }

        it 'creates [e5]' do
          expect(pawn.add_moves(board)).to eq(['e5'])
        end
      end

      context 'when pawn is blocked and no captures are available' do
        subject(:pawn) { described_class.new('e6', 'black') }

        before do
          board.populate_square(Pawn.new('e5', 'white'), 'e5')
        end

        it 'creates []' do
          expect(pawn.add_moves(board)).to eq([])
        end
      end
    end
  end
end

describe Rook do
  context 'when the rook is white' do
    subject(:rook) { described_class.new('a1', 'white') }
    let(:board) { Board.new }

    context 'when the rook is on a1 and the file is open but the rank is closed' do
      before do
        board.populate_square(Pawn.new('b1', 'white'), 'b1')
      end

      it 'creates [a2 a3 a4 a5 a6 a7 a8]' do
        expect(rook.add_moves(board)).to eq(%w[a2 a3 a4 a5 a6 a7 a8])
      end
    end

    context 'when the rook is on a1 and the rank is open but the file is closed' do
      before do
        board.populate_square(Pawn.new('a2', 'white'), 'a2')
      end

      it 'creates [b1 c1 d1 e1 f1 g1 h1]' do
        expect(rook.add_moves(board)).to eq(%w[b1 c1 d1 e1 f1 g1 h1])
      end
    end

    context 'when the rook is on a4 and the file is open' do
      subject(:rook) { described_class.new('a4', 'white') }

      it 'includes [a1 a2 a3 a5 a6 a7 a8]' do
        expect(rook.add_moves(board)).to include('a1', 'a2', 'a3', 'a5', 'a6', 'a7', 'a8')
      end
    end

    context 'when the rook is on a4 and the rank is open' do
      subject(:rook) { described_class.new('d1', 'white') }

      it 'includes [a1 b1 c1 e1 f1 g1 h1]' do
        expect(rook.add_moves(board)).to include('a1', 'b1', 'c1', 'e1', 'f1', 'g1', 'h1')
      end
    end

    context 'when the rook is on c4 and is surrounded by friendly and enemy pieces' do
      subject(:rook) { described_class.new('c4', 'white') }

      before do
        board.populate_square(Pawn.new('c6', 'black'), 'c6')
        board.populate_square(Pawn.new('f4', 'white'), 'f4')
        board.populate_square(Pawn.new('c1', 'white'), 'c1')
        board.populate_square(Pawn.new('a4', 'black'), 'a4')
      end

      it 'includes [c5 c6 d4 e4 c3 c2 b4 a4]' do
        expect(rook.add_moves(board)).to include('c5', 'c6', 'd4', 'e4', 'c3', 'c2', 'b4', 'a4')
      end
    end
  end

  context 'when the rook is black' do
    subject(:rook) { described_class.new('a8', 'black') }
    let(:board) { Board.new }
  
    context 'when the rook is on a8 and the file is open but the rank is closed' do
      before do
        board.populate_square(Pawn.new('b8', 'black'), 'b8')
      end
  
      it 'includes [a1 a2 a3 a4 a5 a6 a7]' do
        expect(rook.add_moves(board)).to include('a1', 'a2', 'a3', 'a4', 'a5', 'a6', 'a7')
      end
    end
  
    context 'when the rook is on a1 and the rank is open but the file is closed' do
      before do
        board.populate_square(Pawn.new('a7', 'black'), 'a7')
      end
  
      it 'creates [b8 c8 d8 e8 f8 g8 h8]' do
        expect(rook.add_moves(board)).to include('b8', 'c8', 'd8', 'e8', 'f8', 'g8', 'h8')
      end
    end
  
    context 'when the rook is on a4 and the file is open' do
      subject(:rook) { described_class.new('a4', 'black') }
  
      before do
        board.populate_square(Pawn.new('b4', 'black'), 'b4')
      end
  
      it 'includes [a1 a2 a3 a5 a6 a7 a8]' do
        expect(rook.add_moves(board)).to include('a1', 'a2', 'a3', 'a5', 'a6', 'a7', 'a8')
      end
    end
  
    context 'when the rook is on a4 and the rank is open' do
      subject(:rook) { described_class.new('d8', 'black') }
  
      before do
        board.populate_square(Pawn.new('d7', 'black'), 'd7')
      end
  
      it 'includes [a8 b8 c8 e8 f8 g8 h8]' do
        expect(rook.add_moves(board)).to include('a8', 'b8', 'c8', 'e8', 'f8', 'g8', 'h8')
      end
    end
  
    context 'when the rook is on c4 and is surrounded by friendly and enemy pieces' do
      subject(:rook) { described_class.new('c4', 'black') }
  
      before do
        board.populate_square(Pawn.new('c6', 'white'), 'c6')
        board.populate_square(Pawn.new('f4', 'black'), 'f4')
        board.populate_square(Pawn.new('c1', 'black'), 'c1')
        board.populate_square(Pawn.new('a4', 'white'), 'a4')
      end
  
      it 'includes [c5 c6 d4 e4 c3 c2 b4 a4]' do
        expect(rook.add_moves(board)).to include('c5', 'c6', 'd4', 'e4', 'c3', 'c2', 'b4', 'a4')
      end
    end  
  end
end

describe Knight do
  context 'when knight is white' do
    subject(:knight) { described_class.new('c3', 'white') }
    let(:board) { Board.new }

    context 'when knight is on c3 and all moves are available' do
      it 'includes [a2 b1 a4 b5 d1 e2 d5 e4]' do
        expect(knight.add_moves(board)).to include('a2', 'b1', 'a4', 'b5', 'd1', 'e2', 'd5', 'e4')
      end
    end

    context 'when knight is on c3 and friendly pawns are on a2 and d5' do
      before do
        board.populate_square(Pawn.new('a2', 'white'), 'a2')
        board.populate_square(Pawn.new('d5', 'white'), 'd5')
      end

      it 'includes [b1 a4 b5 d1 e2 e4]' do
        expect(knight.add_moves(board)).to include('b1', 'a4', 'b5', 'd1', 'e2', 'e4')
      end
    end

    context 'when knight is on c3 and enemy pawns are on a2 and d5' do
      before do
        board.populate_square(Pawn.new('a2', 'black'), 'a2')
        board.populate_square(Pawn.new('d5', 'black'), 'd5')
      end

      it 'includes [a2 b1 a4 b5 d1 e2 d5 e4]' do
        expect(knight.add_moves(board)).to include('a2', 'b1', 'a4', 'b5', 'd1', 'e2', 'd5', 'e4')
      end
    end

    context 'when knight is on a1 and friendly pawns are on a2 and d5' do
      subject(:knight) { described_class.new('a1', 'white') }

      before do
        board.populate_square(Pawn.new('c2', 'white'), 'c2')
        board.populate_square(Pawn.new('b3', 'white'), 'b3')
      end

      it 'has no moves' do
        expect(knight.add_moves(board)).to eq([])
      end
    end
  end

  context 'when knight is black' do
    subject(:knight) { described_class.new('c3', 'black') }
    let(:board) { Board.new }
  
    context 'when knight is on c3 and all moves are available' do
      it 'includes [a2 b1 a4 b5 d1 e2 d5 e4]' do
        expect(knight.add_moves(board)).to include('a2', 'b1', 'a4', 'b5', 'd1', 'e2', 'd5', 'e4')
      end
    end
  
    context 'when knight is on c3 and friendly pawns are on a2 and d5' do
      before do
        board.populate_square(Pawn.new('a2', 'black'), 'a2')
        board.populate_square(Pawn.new('d5', 'black'), 'd5')
      end
  
      it 'includes [b1 a4 b5 d1 e2 e4]' do
        expect(knight.add_moves(board)).to include('b1', 'a4', 'b5', 'd1', 'e2', 'e4')
      end
    end
  
    context 'when knight is on c3 and enemy pawns are on a2 and d5' do
      before do
        board.populate_square(Pawn.new('a2', 'white'), 'a2')
        board.populate_square(Pawn.new('d5', 'white'), 'd5')
      end
  
      it 'includes [a2 b1 a4 b5 d1 e2 d5 e4]' do
        expect(knight.add_moves(board)).to include('a2', 'b1', 'a4', 'b5', 'd1', 'e2', 'd5', 'e4')
      end
    end
  
    context 'when knight is on a1 and friendly pawns are on a2 and d5' do
      subject(:knight) { described_class.new('a1', 'black') }
  
      before do
        board.populate_square(Pawn.new('c2', 'black'), 'c2')
        board.populate_square(Pawn.new('b3', 'black'), 'b3')
      end
  
      it 'has no moves' do
        expect(knight.add_moves(board)).to eq([])
      end
    end  
  end
end

describe Bishop do
  context 'when bishop is white' do
    subject(:bishop) { described_class.new('a1', 'white') }
    let(:board) { Board.new }

    context 'when bishop is on a1 and the diagonal is open' do
      it 'includes [b2 c3 d4 e5 f6 g7 h8]' do
        expect(bishop.add_moves(board)).to eq(%w[b2 c3 d4 e5 f6 g7 h8])
      end
    end

    context 'when bishop is on h1 and the diagonal is open' do
      subject(:bishop) { described_class.new('h1', 'white') }

      it 'includes [g2 f3 e4 d5 c6 b7 a8]' do
        expect(bishop.add_moves(board)).to eq(%w[g2 f3 e4 d5 c6 b7 a8])
      end
    end

    context 'when bishop is on a8 and the diagonal is open' do
      subject(:bishop) { described_class.new('a8', 'white') }

      it 'includes [b7 c6 d5 e4 f3 g2 h1]' do
        expect(bishop.add_moves(board)).to eq(%w[b7 c6 d5 e4 f3 g2 h1])
      end
    end

    context 'when bishop is on h8 and the diagonal is open' do
      subject(:bishop) { described_class.new('h8', 'white') }

      it 'includes [g7 f6 e5 d4 c3 b2 a1]' do
        expect(bishop.add_moves(board)).to eq(%w[g7 f6 e5 d4 c3 b2 a1])
      end
    end

    context 'when bishop is on d5 and is surrounded by friendly and enemy pieces' do
      subject(:bishop) { described_class.new('d5', 'white') }

      before do
        board.populate_square(Pawn.new('f7', 'black'), 'f7')
        board.populate_square(Pawn.new('f3', 'white'), 'f3')
        board.populate_square(Pawn.new('a8', 'black'), 'a8')
        board.populate_square(Pawn.new('b3', 'white'), 'b3')
      end

      it 'includes [e6 f7 e4 c6 b7 a8 c4]' do
        expect(bishop.add_moves(board)).to include('e6', 'f7', 'e4', 'c6', 'b7', 'a8', 'c4')
      end
    end
  end
end

describe Queen do
  context 'when the queen is white' do
    subject(:queen) { described_class.new('d4', 'white') }
    let(:board) { Board.new }

    context 'when queen is on d4 on empty board' do
      it 'includes all moves along files, ranks, and diagonals' do
        expect(queen.add_moves(board)).to include('d5', 'd6', 'd7', 'd8', 'd3', 'd2', 'd1', 'c4', 'b4', 'a4', 'e4', 'f4', 'g4', 'h4', 'c3', 'b2', 'a1', 'e5', 'f6', 'g7', 'h8', 'c5', 'b6', 'a7', 'e3', 'f2', 'g1')
      end
    end

    context 'when queen is on d4 and surrounding by enemy pieces' do
      before do
        board.populate_square(Pawn.new('d5', 'black'), 'd5')
        board.populate_square(Pawn.new('e5', 'black'), 'e5')
        board.populate_square(Pawn.new('e4', 'black'), 'e4')
        board.populate_square(Pawn.new('e3', 'black'), 'e3')
        board.populate_square(Pawn.new('d3', 'black'), 'd3')
        board.populate_square(Pawn.new('c3', 'black'), 'c3')
        board.populate_square(Pawn.new('c4', 'black'), 'c4')
        board.populate_square(Pawn.new('c5', 'black'), 'c5')
      end

      it 'includes capture squares' do
        expect(queen.add_moves(board)).to include('d5', 'e5', 'e4', 'e3', 'd3', 'c3', 'c4', 'c5')
      end
    end

    context 'when queen is on d4 and surrounding by friendly pieces' do
      before do
        board.populate_square(Pawn.new('d5', 'white'), 'd5')
        board.populate_square(Pawn.new('e5', 'white'), 'e5')
        board.populate_square(Pawn.new('e4', 'white'), 'e4')
        board.populate_square(Pawn.new('e3', 'white'), 'e3')
        board.populate_square(Pawn.new('d3', 'white'), 'd3')
        board.populate_square(Pawn.new('c3', 'white'), 'c3')
        board.populate_square(Pawn.new('c4', 'white'), 'c4')
        board.populate_square(Pawn.new('c5', 'white'), 'c5')
      end

      it 'has no moves' do
        expect(queen.add_moves(board)).to eq([])
      end
    end
  end
end

describe King do
  context 'when the king is white' do
    subject(:king) { described_class.new('d4', 'white') }
    let(:board) { Board.new }

    context 'when king is on d4 on empty board' do
      it 'moves available in all directions' do
        expect(king.add_moves(board)).to include('d5', 'e5', 'e4', 'e3', 'd3', 'c3', 'c4', 'c5')
      end
    end

    context 'when king is on d4 and surrounded by enemy pieces' do
      before do
        board.populate_square(Pawn.new('d5', 'black'), 'd5')
        board.populate_square(Pawn.new('e5', 'black'), 'e5')
        board.populate_square(Pawn.new('e4', 'black'), 'e4')
        board.populate_square(Pawn.new('e3', 'black'), 'e3')
        board.populate_square(Pawn.new('d3', 'black'), 'd3')
        board.populate_square(Pawn.new('c3', 'black'), 'c3')
        board.populate_square(Pawn.new('c4', 'black'), 'c4')
        board.populate_square(Pawn.new('c5', 'black'), 'c5')
      end

      it 'includes capture squares' do
        expect(king.add_moves(board)).to include('d5', 'e5', 'e4', 'e3', 'd3', 'c3', 'c4', 'c5')
      end
    end

    context 'when king is on d4 and surrounding by friendly pieces' do
      before do
        board.populate_square(Pawn.new('d5', 'white'), 'd5')
        board.populate_square(Pawn.new('e5', 'white'), 'e5')
        board.populate_square(Pawn.new('e4', 'white'), 'e4')
        board.populate_square(Pawn.new('e3', 'white'), 'e3')
        board.populate_square(Pawn.new('d3', 'white'), 'd3')
        board.populate_square(Pawn.new('c3', 'white'), 'c3')
        board.populate_square(Pawn.new('c4', 'white'), 'c4')
        board.populate_square(Pawn.new('c5', 'white'), 'c5')
      end

      it 'has no moves' do
        expect(king.add_moves(board)).to eq([])
      end
    end
  end
end