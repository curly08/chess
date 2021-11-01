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
end
