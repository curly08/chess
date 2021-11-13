# frozen_string_literal: true

require 'pry-byebug'

require_relative '../lib/player'
require_relative '../lib/board'
require_relative '../lib/pieces'
require_relative '../lib/square'

# core game logic
class Game
  attr_accessor :players, :board
  attr_reader :piece_classes

  def initialize
    @players = []
    @board = Board.new
    @piece_classes = [Pawn, Rook, Knight, Bishop, Queen, King]
  end

  def play_game
    establish_players
    randomize_colors
    players.each { |player| generate_pieces(player) }
    show_board_and_title
    loop do
      puts "#{players[0].color} in check" if in_check?(players[0])
      play_move(players[0])
      show_board_and_title
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

  def generate_pieces(player)
    piece_classes.each do |piece_class|
      start_locations = player.color == 'white' ? piece_class.white_start_locations : piece_class.black_start_locations
      start_locations.each do |location|
        new_piece = piece_class.new(location, player.color)
        board.populate_square(new_piece, location)
        board.pieces << new_piece
      end
    end
  end

  def show_board_and_title
    system('clear') || system('cls')
    puts "#{players[0].name.upcase}(#{players[0].color})    V    #{players[1].name.upcase}(#{players[1].color})\n"
    board.make_grid
  end

  def play_move(player)
    selected_piece = select_piece(player)
    selected_move = select_move(player, selected_piece)
    return castle(selected_piece, selected_move) if selected_piece.is_a?(King) && selected_piece.first_move == true && selected_piece.castle_moves.include?(selected_move)

    move_piece(selected_piece, selected_move)
  end

  def select_piece(player)
    playable_pieces = board.pieces.select { |piece| piece.color == player.color && !piece.legal_moves(board, player).empty? }
    puts "#{player.name}, select a piece to move. Ex. \"#{playable_pieces.sample.location}\""
    loop do
      input = gets.chomp
      selected_piece = playable_pieces.select { |piece| piece.location == input }.pop
      return selected_piece if playable_pieces.include?(selected_piece)

      puts "#{input} is not a valid selection."
    end
  end

  def select_move(player, piece)
    puts "Where would you like to move #{piece.location}? Ex. \"#{piece.legal_moves(board, player).sample}\""
    loop do
      input = gets.chomp
      return input if piece.legal_moves(board, player).include?(input)

      puts "#{input} is not a valid move."
    end
  end

  def castle(king, location)
    king_current_file = king.location.split(//)[0].ord
    file = location.split(//)[0].ord
    rank = location.split(//)[1].to_i
    kingside_rook = board.pieces.select do |piece|
      piece.is_a?(Rook) && piece.color == king.color && piece.location.include?('h')
    end.pop
    queenside_rook = board.pieces.select do |piece|
      piece.is_a?(Rook) && piece.color == king.color && piece.location.include?('a')
    end.pop
    rook = king_current_file < file ? kingside_rook : queenside_rook
    rook_location = king_current_file < file ? [(file - 1).chr, rank].join : [(file + 1).chr, rank].join
    move_piece(king, location)
    move_piece(rook, rook_location)
  end

  def move_piece(piece, location)
    board.pieces.delete_if { |p| p.location == location }
    board.clear_square(piece.location)
    board.populate_square(piece, location)
    piece.first_move = false unless piece.first_move == false
  end

  def in_check?(player)
    king = board.pieces.select { |piece| piece.is_a?(King) && piece.color == player.color }.pop
    board.pieces.any? { |piece| piece.color != player.color && piece.add_moves(board).include?(king.location) }
  end
end
