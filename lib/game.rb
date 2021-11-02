# frozen_string_literal: true

require_relative '../lib/player'
require_relative '../lib/board'
require_relative '../lib/pieces'

# core game logic
class Game
  attr_accessor :players, :board

  def initialize
    @players = Array.new(2)
    @board = Board.new
  end

  def play_game
    establish_players
    randomize_colors
    generate_pieces
    loop do
      players[0].play_move
      return game_over_message if game_over == true

      players.rotate!
    end
  end

  def establish_players
    puts 'Player 1, what is your name?'
    player_one = Player.new(gets.chomp)
    puts 'Player 2, what is your name?'
    player_two = Player.new(gets.chomp)
    players.push(player_one, player_two)
  end

  def randomize_colors
    players.shuffle!
    players[0].color = 'white'
    players[1].color = 'black'
  end

  def generate_pieces
    generate_pawns
    generate_rooks
    generate_knights
    generate_bishops
    generate_queens
    generate_kings
  end

  def generate_pawns
    Pawn.white_starting_locations.each do |location|
      player[0].pieces << Pawn.new(player.color, location)
    end
    Pawn.black_starting_locations.each do |location|
      player[1].pieces << Pawn.new(player.color, location)
    end
  end
end
