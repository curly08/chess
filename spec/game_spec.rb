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
end
