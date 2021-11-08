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
    let(:player_one) { instance_double(Player, name: 'Matt', color: 'white', pieces: []) }
    let(:player_two) { instance_double(Player, name: 'Gary', color: 'black', pieces: []) }

    before do
      game.instance_variable_set(:@players, [player_one, player_two])
    end

    it 'generates 8 pawns for both players' do
      expect { game.generate_pieces(player_one, WhitePawn) }.to change { player_one.pieces.select { |piece| piece.is_a? WhitePawn }.size }.from(0).to(8)
      expect { game.generate_pieces(player_two, BlackPawn) }.to change { player_two.pieces.select { |piece| piece.is_a? BlackPawn }.size }.from(0).to(8)
    end

    it 'generates 2 rooks for both players' do
      expect { game.generate_pieces(player_one, WhiteRook) }.to change { player_one.pieces.select { |piece| piece.is_a? WhiteRook }.size }.from(0).to(2)
      expect { game.generate_pieces(player_two, BlackRook) }.to change { player_two.pieces.select { |piece| piece.is_a? BlackRook }.size }.from(0).to(2)
    end

    it 'generates 2 knights for both players' do
      expect { game.generate_pieces(player_one, WhiteKnight) }.to change { player_one.pieces.select { |piece| piece.is_a? WhiteKnight }.size }.from(0).to(2)
      expect { game.generate_pieces(player_two, BlackKnight) }.to change { player_two.pieces.select { |piece| piece.is_a? BlackKnight }.size }.from(0).to(2)
    end

    it 'generates 2 bishops for both players' do
      expect { game.generate_pieces(player_one, WhiteBishop) }.to change { player_one.pieces.select { |piece| piece.is_a? WhiteBishop }.size }.from(0).to(2)
      expect { game.generate_pieces(player_two, BlackBishop) }.to change { player_two.pieces.select { |piece| piece.is_a? BlackBishop }.size }.from(0).to(2)
    end

    it 'generates 1 queen for both players' do
      expect { game.generate_pieces(player_one, WhiteQueen) }.to change { player_one.pieces.select { |piece| piece.is_a? WhiteQueen }.size }.from(0).to(1)
      expect { game.generate_pieces(player_two, BlackQueen) }.to change { player_two.pieces.select { |piece| piece.is_a? BlackQueen }.size }.from(0).to(1)
    end

    it 'generates 1 king for both players' do
      expect { game.generate_pieces(player_one, WhiteKing) }.to change { player_one.pieces.select { |piece| piece.is_a? WhiteKing }.size }.from(0).to(1)
      expect { game.generate_pieces(player_two, BlackKing) }.to change { player_two.pieces.select { |piece| piece.is_a? BlackKing }.size }.from(0).to(1)
    end
  end
end

describe WhitePawn do
  subject(:pawn) { described_class.new('e2') }
  let(:board) { Board.new }

  describe '#legal_moves' do
    context 'when pawn location is on start location e2 and no captures are available' do
      it 'creates [e3, e4]' do
        expect(pawn.legal_moves(board)).to eq(['e3', 'e4'])
      end
    end

    context 'when pawn location is on start location e2 and with two captures available' do
      before do
        board.populate_square(BlackPawn.new('d3'), 'd3')
        board.populate_square(BlackPawn.new('f3'), 'f3')
      end
      
      it 'creates [e3, e4, d3, f3]' do
        expect(pawn.legal_moves(board)).to eq(['e3', 'e4', 'd3', 'f3'])
      end
    end

    context 'when pawn location is not on start location and no captures are available' do
      subject(:pawn) { described_class.new('e3') }

      it 'creates [e4]' do
        expect(pawn.legal_moves(board)).to eq(['e4'])
      end
    end

    context 'when pawn is blocked and no captures are available' do
      subject(:pawn) { described_class.new('e3') }

      before do
        board.populate_square(BlackPawn.new('e4'), 'e4')
      end

      it 'creates []' do
        expect(pawn.legal_moves(board)).to eq([])
      end
    end
  end
end

describe BlackPawn do
  subject(:pawn) { described_class.new('e7') }
  let(:board) { Board.new }

  describe '#legal_moves' do
    context 'when pawn location is on start location e7 and no captures are available' do
      it 'creates [e6, e5]' do
        expect(pawn.legal_moves(board)).to eq(['e6', 'e5'])
      end
    end

    context 'when pawn location is on start location e2 and with two captures available' do
      before do
        board.populate_square(WhitePawn.new('d6'), 'd6')
        board.populate_square(WhitePawn.new('f6'), 'f6')
      end
      
      it 'creates [e6, e5, d6, f6]' do
        expect(pawn.legal_moves(board)).to eq(%w[e6 e5 d6 f6])
      end
    end

    context 'when pawn location is not on start location and no captures are available' do
      subject(:pawn) { described_class.new('e6') }

      it 'creates [e5]' do
        expect(pawn.legal_moves(board)).to eq(['e5'])
      end
    end

    context 'when pawn is blocked and no captures are available' do
      subject(:pawn) { described_class.new('e6') }

      before do
        board.populate_square(WhitePawn.new('e5'), 'e5')
      end

      it 'creates []' do
        expect(pawn.legal_moves(board)).to eq([])
      end
    end
  end
end

describe WhiteRook do
  subject(:rook) { described_class.new('a1') }
  let(:board) { Board.new }

  context 'when the rook is on a1 and the file is open but the rank is closed' do
    before do
      board.populate_square(WhitePawn.new('b1'), 'b1')
    end

    it 'creates [a2 a3 a4 a5 a6 a7 a8]' do
      expect(rook.legal_moves(board)).to eq(%w[a2 a3 a4 a5 a6 a7 a8])
    end
  end

  context 'when the rook is on a1 and the rank is open but the file is closed' do
    before do
      board.populate_square(WhitePawn.new('a2'), 'a2')
    end

    it 'creates [b1 c1 d1 e1 f1 g1 h1]' do
      expect(rook.legal_moves(board)).to eq(%w[b1 c1 d1 e1 f1 g1 h1])
    end
  end

  context 'when the rook is on a4 and the file is open' do
    subject(:rook) { described_class.new('a4') }

    it 'includes [a1 a2 a3 a5 a6 a7 a8]' do
      expect(rook.legal_moves(board)).to include('a1', 'a2', 'a3', 'a5', 'a6', 'a7', 'a8')
    end
  end

  context 'when the rook is on a4 and the rank is open' do
    subject(:rook) { described_class.new('d1') }

    it 'includes [a1 b1 c1 e1 f1 g1 h1]' do
      expect(rook.legal_moves(board)).to include('a1', 'b1', 'c1', 'e1', 'f1', 'g1', 'h1')
    end
  end

  context 'when the rook is on c4 and is surrounded by friendly and enemy pieces' do
    subject(:rook) { described_class.new('c4') }

    before do
      board.populate_square(BlackPawn.new('c6'), 'c6')
      board.populate_square(WhitePawn.new('f4'), 'f4')
      board.populate_square(WhitePawn.new('c1'), 'c1')
      board.populate_square(BlackPawn.new('a4'), 'a4')
    end

    it 'includes [c5 c6 d4 e4 c3 c2 b4 a4]' do
      expect(rook.legal_moves(board)).to include('c5', 'c6', 'd4', 'e4', 'c3', 'c2', 'b4', 'a4')
    end
  end
end

describe BlackRook do
  subject(:rook) { described_class.new('a8') }
  let(:board) { Board.new }

  context 'when the rook is on a8 and the file is open but the rank is closed' do
    before do
      board.populate_square(BlackPawn.new('b8'), 'b8')
    end

    it 'includes [a1 a2 a3 a4 a5 a6 a7]' do
      expect(rook.legal_moves(board)).to include('a1', 'a2', 'a3', 'a4', 'a5', 'a6', 'a7')
    end
  end

  context 'when the rook is on a1 and the rank is open but the file is closed' do
    before do
      board.populate_square(BlackPawn.new('a7'), 'a7')
    end

    it 'creates [b8 c8 d8 e8 f8 g8 h8]' do
      expect(rook.legal_moves(board)).to include('b8', 'c8', 'd8', 'e8', 'f8', 'g8', 'h8')
    end
  end

  context 'when the rook is on a4 and the file is open' do
    subject(:rook) { described_class.new('a4') }

    before do
      board.populate_square(BlackPawn.new('b4'), 'b4')
    end

    it 'includes [a1 a2 a3 a5 a6 a7 a8]' do
      expect(rook.legal_moves(board)).to include('a1', 'a2', 'a3', 'a5', 'a6', 'a7', 'a8')
    end
  end

  context 'when the rook is on a4 and the rank is open' do
    subject(:rook) { described_class.new('d8') }

    before do
      board.populate_square(BlackPawn.new('d7'), 'd7')
    end

    it 'includes [a8 b8 c8 e8 f8 g8 h8]' do
      expect(rook.legal_moves(board)).to include('a8', 'b8', 'c8', 'e8', 'f8', 'g8', 'h8')
    end
  end

  context 'when the rook is on c4 and is surrounded by friendly and enemy pieces' do
    subject(:rook) { described_class.new('c4') }

    before do
      board.populate_square(WhitePawn.new('c6'), 'c6')
      board.populate_square(BlackPawn.new('f4'), 'f4')
      board.populate_square(BlackPawn.new('c1'), 'c1')
      board.populate_square(WhitePawn.new('a4'), 'a4')
    end

    it 'includes [c5 c6 d4 e4 c3 c2 b4 a4]' do
      expect(rook.legal_moves(board)).to include('c5', 'c6', 'd4', 'e4', 'c3', 'c2', 'b4', 'a4')
    end
  end
end

describe WhiteKnight do
  subject(:knight) { described_class.new('c3') }
  let(:board) { Board.new }

  context 'when knight is on c3 and all moves are available' do
    it 'includes [a2 b1 a4 b5 d1 e2 d5 e4]' do
      expect(knight.legal_moves(board)).to include('a2', 'b1', 'a4', 'b5', 'd1', 'e2', 'd5', 'e4')
    end
  end

  context 'when knight is on c3 and friendly pawns are on a2 and d5' do
    before do
      board.populate_square(WhitePawn.new('a2'), 'a2')
      board.populate_square(WhitePawn.new('d5'), 'd5')
    end

    it 'includes [b1 a4 b5 d1 e2 e4]' do
      expect(knight.legal_moves(board)).to include('b1', 'a4', 'b5', 'd1', 'e2', 'e4')
    end
  end

  context 'when knight is on c3 and enemy pawns are on a2 and d5' do
    before do
      board.populate_square(BlackPawn.new('a2'), 'a2')
      board.populate_square(BlackPawn.new('d5'), 'd5')
    end

    it 'includes [a2 b1 a4 b5 d1 e2 d5 e4]' do
      expect(knight.legal_moves(board)).to include('a2', 'b1', 'a4', 'b5', 'd1', 'e2', 'd5', 'e4')
    end
  end

  context 'when knight is on a1 and friendly pawns are on a2 and d5' do
    subject(:knight) { described_class.new('a1') }

    before do
      board.populate_square(WhitePawn.new('c2'), 'c2')
      board.populate_square(WhitePawn.new('b3'), 'b3')
    end

    it 'has no moves' do
      expect(knight.legal_moves(board)).to eq([])
    end
  end
end
