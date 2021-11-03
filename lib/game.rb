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
    show_board
    loop do
      play_move(players[0])
      show_board
      # return game_over_message if game_over == true

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

  def generate_pieces(player, piece_class)
    starting_locations = player.color == 'white' ? piece_class.white_starting_locations : piece_class.black_starting_locations
    starting_locations.each do |location|
      new_piece = piece_class.new(player.color, location)
      board.populate_square(new_piece, location)
      player.pieces << new_piece
    end
  end

  def show_board
    system('clear') || system('cls')
    puts "#{players[0].name.upcase}(#{players[0].color})    V    #{players[1].name.upcase}(#{players[1].color})\n"
    board.make_grid
  end

  def play_move(player)
    selected_piece = player.select_piece
    selected_move = player.select_move(selected_piece)
    board.clear_square(selected_piece.location)
    board.populate_square(selected_piece, selected_move)
  end
end
