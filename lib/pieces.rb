# frozen_string_literal: true

require_relative '../lib/piece_movement'

# Piece superclass
class Piece
  attr_accessor :location, :first_move
  attr_reader :color, :symbol, :start_locations

  def initialize(location, color)
    @location = location
    @color = color
    @start_locations = color == 'white' ? self.class.white_start_locations : self.class.black_start_locations
    @first_move = true
  end

  class << self
    attr_reader :white_start_locations, :black_start_locations
  end

  def legal_moves(board, player)
    moves = add_moves(board)
    filter_for_check(moves, board, player)
    moves
  end

  def filter_for_check(moves, board, player)
    moves.reject! do |move|
      new_board = copy_board(board)
      dummy_piece = new_board.pieces.select { |piece| piece.location == location }.pop
      new_board.pieces.delete_if { |p| p.location == move }
      new_board.clear_square(location)
      new_board.populate_square(dummy_piece, move)
      in_check?(new_board, player)
    end
  end

  def copy_board(board)
    new_board = Marshal.load(Marshal.dump(board))
    new_board.pieces = copy_pieces(board)
    new_board.squares = new_board.make_squares
    new_board.pieces.each do |piece|
      new_board.populate_square(piece, piece.location)
    end
    new_board
  end

  def copy_pieces(board)
    new_pieces = []
    board.pieces.each do |piece|
      new_piece = Marshal.load(Marshal.dump(piece))
      new_pieces << new_piece
    end
    new_pieces
  end

  def in_check?(board, player)
    king = board.pieces.select { |piece| piece.is_a?(King) && piece.color == player.color }.pop
    board.pieces.any? { |piece| piece.color != player.color && piece.add_moves(board).include?(king.location) }
  end
end

# Pawn class
class Pawn < Piece
  include PawnMovement
  attr_accessor :en_passant_risk

  @white_start_locations = %w[a2 b2 c2 d2 e2 f2 g2 h2]
  @black_start_locations = %w[a7 b7 c7 d7 e7 f7 g7 h7]

  def initialize(location, color)
    super
    @symbol = color == 'white' ? "\u2659".encode('utf-8') : "\u265F".encode('utf-8')
    @en_passant_risk = false
  end

  def add_moves(board)
    pawn_moves(board)
  end
end

# Rook class
class Rook < Piece
  include HorizontalVerticalMovement
  @white_start_locations = %w[a1 h1]
  @black_start_locations = %w[a8 h8]

  def initialize(location, color)
    super
    @symbol = color == 'white' ? "\u2656".encode('utf-8') : "\u265C".encode('utf-8')
  end

  def add_moves(board)
    horizontal_vertical_moves(board)
  end
end

# Knight class
class Knight < Piece
  include KnightMovement
  @white_start_locations = %w[b1 g1]
  @black_start_locations = %w[b8 g8]

  def initialize(location, color)
    super
    @symbol = color == 'white' ? "\u2658".encode('utf-8') : "\u265E".encode('utf-8')
  end

  def add_moves(board)
    knight_moves(board)
  end
end

# Bishop class
class Bishop < Piece
  include DiagonalMovement
  @white_start_locations = %w[c1 f1]
  @black_start_locations = %w[c8 f8]

  def initialize(location, color)
    super
    @symbol = color == 'white' ? "\u2657".encode('utf-8') : "\u265D".encode('utf-8')
  end

  def add_moves(board)
    diagonal_moves(board)
  end
end

# Queen class
class Queen < Piece
  include HorizontalVerticalMovement
  include DiagonalMovement
  @white_start_locations = %w[d1]
  @black_start_locations = %w[d8]

  def initialize(location, color)
    super
    @symbol = color == 'white' ? "\u2655".encode('utf-8') : "\u265B".encode('utf-8')
  end

  def legal_moves(board, player)
    moves = add_moves(board)
    filter_for_check(moves, board, player)
    moves
  end

  def add_moves(board)
    horizontal_vertical_moves(board) + diagonal_moves(board)
  end
end

# King class
class King < Piece
  include KingMovement
  @white_start_locations = %w[e1]
  @black_start_locations = %w[e8]

  def initialize(location, color)
    super
    @symbol = color == 'white' ? "\u2654".encode('utf-8') : "\u265A".encode('utf-8')
  end

  def add_moves(board)
    king_moves(board)
  end
end
