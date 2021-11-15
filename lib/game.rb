# frozen_string_literal: true

require 'yaml'
require_relative '../lib/player'
require_relative '../lib/board'
require_relative '../lib/pieces'
require_relative '../lib/square'

# core game logic
class Game
  attr_accessor :players, :board, :current_player, :player_one, :player_two
  attr_reader :piece_classes

  def initialize(data = {})
    @players = data.fetch(:players, [])
    @board = data.fetch(:board, Board.new)
    @piece_classes = [Pawn, Rook, Knight, Bishop, Queen, King]
    @player_one = data.fetch(:player_one, nil)
    @player_two = data.fetch(:player_two, nil)
    @current_player = data.fetch(:current_player, nil)
  end

  def play
    set_up_game
    play_game
  end

  def set_up_game
    establish_players
    randomize_colors
    players.each { |player| generate_pieces(player) }
  end

  def play_game
    show_board_and_title
    loop do
      current_player = players[0]
      play_move(current_player)
      show_board_and_title
      break if game_over?

      players.rotate!
    end
  end

  def establish_players
    puts 'Player 1, what is your name?'
    @player_one = Player.new(gets.chomp)
    choose_opponent
    players.push(player_one, player_two)
  end

  def choose_opponent
    puts 'Type 1 to play against another human or 2 to play against the computer.'
    loop do
      input = gets.chomp
      return human_player_two if input == '1'
      return computer_player_two if input == '2'

      puts "#{input} is not a valid input."
    end
  end

  def human_player_two
    puts 'Player 2, what is your name?'
    @player_two = Player.new(gets.chomp)
  end

  def computer_player_two
    @player_two = ComputerPlayer.new
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
    puts "Enter 'resign' to resign or 'save' to save and exit your game."
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
    return playable_pieces.sample if player.is_a?(ComputerPlayer)

    puts "#{player.name}, select a piece to move. Ex. \"#{playable_pieces.sample.location}\""
    loop do
      input = gets.chomp
      return resign(player) if input == 'resign'

      save_and_exit_game if input == 'save'
      selected_piece = playable_pieces.select { |piece| piece.location == input }.pop
      return selected_piece if playable_pieces.include?(selected_piece)

      puts "#{input} is not a valid selection."
    end
  end

  def select_move(player, piece)
    return piece.legal_moves(board, player).sample if player.is_a?(ComputerPlayer)

    puts "Where would you like to move #{piece.location}? Ex. \"#{piece.legal_moves(board, player).sample}\""
    loop do
      input = gets.chomp
      return resign(player) if input == 'resign'

      save_and_exit_game if input == 'save'
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
    puts 'What do you want to promote your pawn to? Ex. "queen"'
    input = nil
    loop do
      input = gets.chomp
      break if legal_promotions.include?(input)

      puts "#{input} is not a valid input."
    end
    new_piece = Object.const_get(input.capitalize).new(square, pawn.color)
    board.pieces << new_piece
    board.populate_square(new_piece, square)
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
    exit #rematch
  end

  def self.load_game?
    puts 'Type 1 to play a new game or 2 to load a previous game.'
    loop do
      input = gets.chomp
      return Game.new.play if input == '1'
      return Game.from_yaml if input == '2'

      puts "#{input} is not a valid input."
    end
  end

  def save_and_exit_game
    Dir.mkdir('saved-games') unless Dir.exist?('saved-games')
    puts "\nWhat would you like to save your game as?"
    begin
      input = gets.chomp
      raise 'Invalid filename!' unless input.match?(/^[A-Za-z0-9._ -]+$/i)

      filename = "saved-games/#{input}.yaml"
      File.open(filename, 'w') { |file| file.puts to_yaml }
    rescue StandardError => e
      puts e.to_s
      retry
    end
    exit
  end

  def to_yaml
    YAML.dump({ players: @players,
                board: @board,
                player_one: @player_one,
                player_two: @player_two,
                current_player: @current_player })
  end

  def self.from_yaml
    puts 'Which game do you want to load?'
    input = gets.chomp
    data = YAML.load(File.read("saved-games/#{input}.yaml"))
    Game.new(data).play_game
  end
end
