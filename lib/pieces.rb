# frozen_string_literal: true

# Pawn class
class Pawn
  attr_accessor :location
  attr_reader :color, :symbol

  @white_starting_locations = %w[a2 b2 c2 d2 e2 f2 g2 h2]
  @black_starting_locations = %w[a7 b7 c7 d7 e7 f7 g7 h7]

  def initialize(color, location)
    @symbol = 'p'
    @color = color
    @location = location
    @legal_moves = []
  end

  class << self
    attr_reader :white_starting_locations, :black_starting_locations
  end
end

# Rook class
class Rook
  attr_accessor :location
  attr_reader :color, :symbol

  @white_starting_locations = %w[a1 h1]
  @black_starting_locations = %w[a8 h8]

  def initialize(color, location)
    @symbol = 'R'
    @color = color
    @location = location
    @legal_moves = []
  end

  class << self
    attr_reader :white_starting_locations, :black_starting_locations
  end
end
