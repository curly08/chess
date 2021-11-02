# frozen_string_literal: true

require 'pry-byebug'

require_relative '../lib/player'
require_relative '../lib/board'
require_relative '../lib/pieces'
require_relative '../lib/space'

# core game logic
class Game
  attr_accessor :players, :board

  def initialize
    @players = []
    @board = Board.new
  end

  def play_game
    establish_players
    randomize_colors
    players.each { |player| generate_pieces(player) }
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

  def generate_pieces(player)
    generate_pawns(player)
  end

  def generate_pawns(player)
    starting_locations = player.color == 'white' ? Pawn.white_starting_locations : Pawn.black_starting_locations
    starting_locations.each do |location|
      new_pawn = Pawn.new(player.color, location)
      populate_square(new_pawn, location)
      player.pieces << new_pawn
    end
  end

  def populate_square(new_piece, piece_location)
    square = board.spaces.select { |space| space.location == piece_location }.pop
    square.piece = new_piece
    square.data = new_piece.symbol
  end
end

# game = Game.new
# binding.pry
# game.play_game