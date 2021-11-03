# frozen_string_literal: true

# Piece superclass
class Piece
  attr_accessor :location
  attr_reader :color, :symbol

  def initialize(color, location)
    @color = color
    @location = location
  end

  class << self
    attr_reader :white_starting_locations, :black_starting_locations
  end
end

# Pawn class
class Pawn < Piece
  @white_starting_locations = %w[a2 b2 c2 d2 e2 f2 g2 h2]
  @black_starting_locations = %w[a7 b7 c7 d7 e7 f7 g7 h7]

  def initialize(color, location)
    super
    @symbol = color == 'white' ? "\u2659".encode('utf-8') : "\u265F".encode('utf-8')
    @legal_moves = []
  end
end

# Rook class
class Rook < Piece
  @white_starting_locations = %w[a1 h1]
  @black_starting_locations = %w[a8 h8]

  def initialize(color, location)
    super
    @symbol = color == 'white' ? "\u2656".encode('utf-8') : "\u265C".encode('utf-8')
    @legal_moves = []
  end
end

# Knight class
class Knight < Piece
  @white_starting_locations = %w[b1 g1]
  @black_starting_locations = %w[b8 g8]

  def initialize(color, location)
    super
    @symbol = color == 'white' ? "\u2658".encode('utf-8') : "\u265E".encode('utf-8')
    @legal_moves = []
  end
end
