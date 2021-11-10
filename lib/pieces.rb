# frozen_string_literal: true

require_relative '../lib/piece_movement'

# Piece superclass
class Piece
  attr_accessor :location, :moves
  attr_reader :color, :symbol, :start_locations

  def initialize(location, color)
    @location = location
    @color = color
    @start_locations = color == 'white' ? self.class.white_start_locations : self.class.black_start_locations
  end

  class << self
    attr_reader :white_start_locations, :black_start_locations
  end
end

# Pawn class
class Pawn < Piece
  include PawnMovement
  @white_start_locations = %w[a2 b2 c2 d2 e2 f2 g2 h2]
  @black_start_locations = %w[a7 b7 c7 d7 e7 f7 g7 h7]

  def initialize(location, color)
    super
    @symbol = color == 'white' ? "\u2659".encode('utf-8') : "\u265F".encode('utf-8')
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

  def generate_moves(board)
    @moves = []
    add_horizontal_and_vertical_moves(board)
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

  def generate_moves(board)
    @moves = []
    add_knight_moves(board)
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

  def generate_moves(board)
    @moves = []
    add_diagonal_moves(board)
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

  def generate_moves(board)
    @moves = []
    add_horizontal_and_vertical_moves(board)
    add_diagonal_moves(board)
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

  def generate_moves(board)
    @moves = []
    add_king_moves(board)
  end
end
