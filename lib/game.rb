# frozen_string_literal: true

require 'pry-byebug'

require_relative '../lib/player'
require_relative '../lib/board'
require_relative '../lib/pieces'
require_relative '../lib/square'

# core game logic
class Game
  attr_accessor :players, :board
  attr_reader :piece_classes, :player_one, :player_two

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
      play_move(players[0])
      show_board_and_title
      break if game_over?

      players.rotate!
    end
  end

  def establish_players
    puts 'Player 1, what is your name?'
    @player_one = Player.new(gets.chomp)
    puts 'Player 2, what is your name?'
    @player_two = Player.new(gets.chomp)
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
    puts "#{player_one.name} (#{player_one.color})    V    #{player_two.name} (#{player_two.color})\n"
    players.each { |player| puts "#{player.color} in check" if in_check?(player) }
    board.make_grid
  end

  def play_move(player)
    reset_en_passant_risk(player)
    selected_piece = select_piece(player)
    selected_move = select_move(player, selected_piece)
    en_passant_risk?(selected_piece, selected_move) if selected_piece.is_a?(Pawn)
    en_passant_capture(selected_piece, selected_move) if selected_piece.is_a?(Pawn)
    if selected_piece.is_a?(Pawn) && ((selected_move.include?('8') if selected_piece.color == 'white') || (selected_move.include?('1') if selected_piece.color == 'black'))
      return promotion(selected_piece, selected_move)
    end
    if selected_piece.is_a?(King) && selected_piece.first_move == true && selected_piece.castle_moves.include?(selected_move)
      return castle(selected_piece, selected_move)
    end

    move_piece(selected_piece, selected_move)
  end

  def reset_en_passant_risk(player)
    pawns = board.pieces.select { |piece| piece.color == player.color && piece.is_a?(Pawn) }
    pawns.each { |pawn| pawn.en_passant_risk = false if pawn.en_passant_risk == true }
  end

  def en_passant_risk?(pawn, move)
    current_rank = pawn.location.split(//)[1].to_i
    new_rank = move.split(//)[1].to_i
    difference = current_rank < new_rank ? new_rank - current_rank : current_rank - new_rank
    pawn.en_passant_risk = true if difference == 2
  end

  def en_passant_capture(pawn, move)
    current_file = pawn.location.split(//)[0].ord
    current_rank = pawn.location.split(//)[1].to_i
    new_file = move.split(//)[0].ord
    new_square = board.squares.select { |square| square.location == move }.pop
    captured_location = [new_file.chr, current_rank].join
    return unless current_file != new_file && new_square.piece.nil?

    board.pieces.delete_if { |p| p.location == captured_location }
    board.clear_square(captured_location)
  end

  def select_piece(player)
    playable_pieces = board.pieces.select { |piece| piece.color == player.color && !piece.legal_moves(board, player).empty? }
    puts "#{player.name}, select a piece to move. Ex. \"#{playable_pieces.sample.location}\""
    loop do
      input = gets.chomp
      return resign(player) if input == 'resign'

      selected_piece = playable_pieces.select { |piece| piece.location == input }.pop
      return selected_piece if playable_pieces.include?(selected_piece)

      puts "#{input} is not a valid selection."
    end
  end

  def select_move(player, piece)
    puts "Where would you like to move #{piece.location}? Ex. \"#{piece.legal_moves(board, player).sample}\""
    loop do
      input = gets.chomp
      return resign(player) if input == 'resign'

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

  def promotion(pawn, square)
    legal_promotions = %w[queen rook bishop knight]
    # ask what class to promote to
    puts 'What do you want to promote your pawn to? Ex. "queen"'
    input = nil
    loop do
      input = gets.chomp
      break if legal_promotions.include?(input)

      puts "#{input} is not a valid input."
    end
    # add new piece to board
    new_piece = Object.const_get(input.capitalize).new(square, pawn.color)
    board.pieces << new_piece
    board.populate_square(new_piece, square)
    # delete pawn from board.pieces
    board.clear_square(pawn.location)
    board.pieces.delete_if { |piece| piece == pawn }
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

  def game_over?
    puts "Checkmate! #{players[0].name} wins!" if checkmate?
    puts "It's a stalemate!" if stalemate?
    puts "It's a dead position!" if dead_position?
    return true if checkmate? || stalemate? || dead_position?

    false
  end

  def checkmate?
    in_check?(players[1]) && board.pieces.none? { |piece| piece.color == players[1].color && !piece.legal_moves(board, players[1]).empty? }
  end

  def stalemate?
    players.any? do |player|
      !in_check?(player) && board.pieces.none? { |piece| piece.color == player.color && !piece.legal_moves(board, player).empty? }
    end
  end

  def dead_position?
    board.pieces.all? { |piece| piece.is_a?(King) }
  end

  def resign(resigning_player)
    opponent = players.reject { |player| player == resigning_player }.pop
    puts "#{resigning_player.name} has resigned. #{opponent.name} wins!"
    exit
  end
end
