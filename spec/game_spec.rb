# frozen_string_literal: true

# rubocop:disable all

require_relative '../lib/game'

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
      expect { game.generate_pieces(player_one, Pawn) }.to change { player_one.pieces.select { |piece| piece.is_a? Pawn }.size }.from(0).to(8)
      expect { game.generate_pieces(player_two, Pawn) }.to change { player_two.pieces.select { |piece| piece.is_a? Pawn }.size }.from(0).to(8)
    end

    it 'generates 2 rooks for both players' do
      expect { game.generate_pieces(player_one, Rook) }.to change { player_one.pieces.select { |piece| piece.is_a? Rook }.size }.from(0).to(2)
      expect { game.generate_pieces(player_two, Rook) }.to change { player_two.pieces.select { |piece| piece.is_a? Rook }.size }.from(0).to(2)
    end

    it 'generates 2 knights for both players' do
      expect { game.generate_pieces(player_one, Knight) }.to change { player_one.pieces.select { |piece| piece.is_a? Knight }.size }.from(0).to(2)
      expect { game.generate_pieces(player_two, Knight) }.to change { player_two.pieces.select { |piece| piece.is_a? Knight }.size }.from(0).to(2)
    end

    it 'generates 2 bishops for both players' do
      expect { game.generate_pieces(player_one, Bishop) }.to change { player_one.pieces.select { |piece| piece.is_a? Bishop }.size }.from(0).to(2)
      expect { game.generate_pieces(player_two, Bishop) }.to change { player_two.pieces.select { |piece| piece.is_a? Bishop }.size }.from(0).to(2)
    end

    it 'generates 1 queen for both players' do
      expect { game.generate_pieces(player_one, Queen) }.to change { player_one.pieces.select { |piece| piece.is_a? Queen }.size }.from(0).to(1)
      expect { game.generate_pieces(player_two, Queen) }.to change { player_two.pieces.select { |piece| piece.is_a? Queen }.size }.from(0).to(1)
    end

    it 'generates 1 king for both players' do
      expect { game.generate_pieces(player_one, King) }.to change { player_one.pieces.select { |piece| piece.is_a? King }.size }.from(0).to(1)
      expect { game.generate_pieces(player_two, King) }.to change { player_two.pieces.select { |piece| piece.is_a? King }.size }.from(0).to(1)
    end
  end
end
