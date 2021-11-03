# frozen_string_literal: true

require 'pry-byebug'

require_relative '../lib/player'
require_relative '../lib/board'
require_relative '../lib/pieces'
require_relative '../lib/square'

# core game logic
class Game
  attr_accessor :players, :board
  attr_reader :pieces

  def initialize
    @players = []
    @board = Board.new
    @pieces = [Pawn, Rook, Knight, Bishop, Queen, King]
  end

  def play_game
    establish_players
    randomize_colors
    players.each do |player|
      pieces.each { |piece_type| generate_pieces(player, piece_type) }
    end
    board.make_grid
    # loop do
    #   players[0].play_move
    #   return game_over_message if game_over == true

    #   players.rotate!
    # end
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

  def generate_pieces(player, piece_class)
    starting_locations = player.color == 'white' ? piece_class.white_starting_locations : piece_class.black_starting_locations
    starting_locations.each do |location|
      new_piece = piece_class.new(player.color, location)
      populate_square(new_piece, location)
      player.pieces << new_piece
    end
  end

  def populate_square(new_piece, piece_location)
    selected_square = board.squares.select { |square| square.location == piece_location }.pop
    selected_square.piece = new_piece
    selected_square.data = new_piece.symbol
  end
end

game = Game.new
# binding.pry
game.play_game
