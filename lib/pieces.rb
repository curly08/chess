# frozen_string_literal: true

# White Piece superclass
class WhitePiece
  attr_accessor :location, :legal_moves
  attr_reader :color, :symbol

  def initialize(location)
    @location = location
    @color = 'white'
  end

  class << self
    attr_reader :starting_locations
  end
end

# Black Piece superclass
class BlackPiece
  attr_accessor :location, :legal_moves
  attr_reader :color, :symbol

  def initialize(location)
    @location = location
    @color = 'black'
  end

  class << self
    attr_reader :starting_locations
  end
end

# White Pawn class
class WhitePawn < WhitePiece
  @starting_locations = %w[a2 b2 c2 d2 e2 f2 g2 h2]

  def initialize(location)
    super
    @symbol = "\u2659".encode('utf-8')
  end

  def legal_moves(board)
    file = location.split(//)[0].ord
    rank = location.split(//)[1].to_i
    moveset = []
    up_one = [file.chr, rank + 1].join
    up_two = [file.chr, rank + 2].join
    capture_left = [(file - 1).chr, rank + 1].join
    capture_left_square = board.squares.select { |square| square.location == capture_left }.pop
    capture_right = [(file + 1).chr, rank + 1].join
    capture_right_square = board.squares.select { |square| square.location == capture_right }.pop
    moveset << up_one if board.squares.select { |square| square.location == up_one }.pop.piece.nil?
    moveset << up_two if WhitePawn.starting_locations.include?(location)
    moveset << capture_left if !capture_left_square.piece.nil? && capture_left_square.piece.color == 'black'
    moveset << capture_right if !capture_right_square.piece.nil? && capture_right_square.piece.color == 'black'
    moveset
  end
end

# Black Pawn class
class BlackPawn < BlackPiece
  @starting_locations = %w[a7 b7 c7 d7 e7 f7 g7 h7]

  def initialize(location)
    super
    @symbol = "\u265F".encode('utf-8')
  end

  def legal_moves(board)
    file = location.split(//)[0].ord
    rank = location.split(//)[1].to_i
    moveset = []
    down_one = [file.chr, rank - 1].join
    down_two = [file.chr, rank - 2].join
    capture_left = [(file - 1).chr, rank - 1].join
    capture_left_square = board.squares.select { |square| square.location == capture_left }.pop
    capture_right = [(file + 1).chr, rank - 1].join
    capture_right_square = board.squares.select { |square| square.location == capture_right }.pop
    moveset << down_one if board.squares.select { |square| square.location == down_one }.pop.piece.nil?
    moveset << down_two if BlackPawn.starting_locations.include?(location)
    moveset << capture_left if !capture_left_square.piece.nil? && capture_left_square.piece.color == 'white'
    moveset << capture_right if !capture_right_square.piece.nil? && capture_right_square.piece.color == 'white'
    moveset
  end
end

# White Rook class
class WhiteRook < WhitePiece
  @starting_locations = %w[a1 h1]

  def initialize(location)
    super
    @symbol = "\u2656".encode('utf-8')
  end

  def legal_moves(board)
    file = location.split(//)[0].ord
    rank = location.split(//)[1].to_i
    moveset = []
    moves_below_rank(board, file, rank, moveset)
    moves_above_rank(board, file, rank, moveset)
    moves_left_of_file(board, file, rank, moveset)
    moves_right_of_file(board, file, rank, moveset)
    moveset
  end

  def moves_above_rank(board, file, rank, moveset)
    ((rank + 1)..8).each do |r|
      location = [file.chr, r].join
      space = board.squares.select { |square| square.location == location }.pop
      break if !space.piece.nil? && space.piece.color == 'white'

      moveset << location
      break if !space.piece.nil? && space.piece.color == 'black'
    end
  end

  def moves_below_rank(board, file, rank, moveset)
    (1..(rank - 1)).reverse_each do |r|
      location = [file.chr, r].join
      space = board.squares.select { |square| square.location == location }.pop
      break if !space.piece.nil? && space.piece.color == 'white'

      moveset << location
      break if !space.piece.nil? && space.piece.color == 'black'
    end
  end

  def moves_right_of_file(board, file, rank, moveset)
    ((file + 1)..('h'.ord)).each do |f|
      location = [f.chr, rank].join
      space = board.squares.select { |square| square.location == location }.pop
      break if !space.piece.nil? && space.piece.color == 'white'

      moveset << location
      break if !space.piece.nil? && space.piece.color == 'black'
    end
  end

  def moves_left_of_file(board, file, rank, moveset)
    (('a'.ord)..(file - 1)).reverse_each do |f|
      location = [f.chr, rank].join
      space = board.squares.select { |square| square.location == location }.pop
      break if !space.piece.nil? && space.piece.color == 'white'

      moveset << location
      break if !space.piece.nil? && space.piece.color == 'black'
    end
  end
end

# Black Rook class
class BlackRook < BlackPiece
  @starting_locations = %w[a8 h8]

  def initialize(location)
    super
    @symbol = "\u265C".encode('utf-8')
  end

  def legal_moves(board)
    file = location.split(//)[0].ord
    rank = location.split(//)[1].to_i
    moveset = []
    moves_below_rank(board, file, rank, moveset)
    moves_above_rank(board, file, rank, moveset)
    moves_left_of_file(board, file, rank, moveset)
    moves_right_of_file(board, file, rank, moveset)
    moveset
  end

  def moves_above_rank(board, file, rank, moveset)
    ((rank + 1)..8).each do |r|
      location = [file.chr, r].join
      space = board.squares.select { |square| square.location == location }.pop
      break if !space.piece.nil? && space.piece.color == 'black'

      moveset << location
      break if !space.piece.nil? && space.piece.color == 'white'
    end
  end

  def moves_below_rank(board, file, rank, moveset)
    (1..(rank - 1)).reverse_each do |r|
      location = [file.chr, r].join
      space = board.squares.select { |square| square.location == location }.pop
      break if !space.piece.nil? && space.piece.color == 'black'

      moveset << location
      break if !space.piece.nil? && space.piece.color == 'white'
    end
  end

  def moves_right_of_file(board, file, rank, moveset)
    ((file + 1)..('h'.ord)).each do |f|
      location = [f.chr, rank].join
      space = board.squares.select { |square| square.location == location }.pop
      break if !space.piece.nil? && space.piece.color == 'black'

      moveset << location
      break if !space.piece.nil? && space.piece.color == 'white'
    end
  end

  def moves_left_of_file(board, file, rank, moveset)
    (('a'.ord)..(file - 1)).reverse_each do |f|
      location = [f.chr, rank].join
      space = board.squares.select { |square| square.location == location }.pop
      break if !space.piece.nil? && space.piece.color == 'black'

      moveset << location
      break if !space.piece.nil? && space.piece.color == 'white'
    end
  end
end

# White Knight class
class WhiteKnight < WhitePiece
  @starting_locations = %w[b1 g1]

  def initialize(location)
    super
    @symbol = "\u2658".encode('utf-8')
  end

  def legal_moves(board)
    file = location.split(//)[0].ord
    rank = location.split(//)[1].to_i
    moveset = []
    [
      [(file + 1).chr, rank + 2].join,
      [(file + 2).chr, rank + 1].join,
      [(file + 2).chr, rank - 1].join,
      [(file + 1).chr, rank - 2].join,
      [(file - 1).chr, rank - 2].join,
      [(file - 2).chr, rank - 1].join,
      [(file - 2).chr, rank + 1].join,
      [(file - 1).chr, rank + 2].join
    ].each do |move|
      space = board.squares.select { |square| square.location == move }.pop
      next if space.nil?

      moveset << move if space.piece.nil? || space.piece.color == 'black'
    end
    moveset
  end
end

# Black Knight class
class BlackKnight < BlackPiece
  @starting_locations = %w[b8 g8]

  def initialize(location)
    super
    @symbol = "\u265E".encode('utf-8')
  end

  def legal_moves(board)
    file = location.split(//)[0].ord
    rank = location.split(//)[1].to_i
    moveset = []
    [
      [(file + 1).chr, rank + 2].join,
      [(file + 2).chr, rank + 1].join,
      [(file + 2).chr, rank - 1].join,
      [(file + 1).chr, rank - 2].join,
      [(file - 1).chr, rank - 2].join,
      [(file - 2).chr, rank - 1].join,
      [(file - 2).chr, rank + 1].join,
      [(file - 1).chr, rank + 2].join
    ].each do |move|
      space = board.squares.select { |square| square.location == move }.pop
      next if space.nil?

      moveset << move if space.piece.nil? || space.piece.color == 'white'
    end
    moveset
  end
end

# White Bishop class
class WhiteBishop < WhitePiece
  @starting_locations = %w[c1 f1]

  def initialize(location)
    super
    @symbol = "\u2657".encode('utf-8')
  end

  def legal_moves(board)
    file = location.split(//)[0].ord
    rank = location.split(//)[1].to_i
    moveset = []
    moves_up_and_right(board, file, rank, moveset)
    moves_up_and_left(board, file, rank, moveset)
    moves_down_and_right(board, file, rank, moveset)
    moves_down_and_left(board, file, rank, moveset)
    moveset
  end

  def moves_up_and_right(board, file, rank, moveset)
    while (file - 97) < 8 || rank < 8
      file += 1
      rank += 1
      location = [file.chr, rank].join
      space = board.squares.select { |square| square.location == location }.pop
      break if space.nil?
      break if !space.piece.nil? && space.piece.color == 'white'

      moveset << location
      break if !space.piece.nil? && space.piece.color == 'black'
    end
  end

  def moves_up_and_left(board, file, rank, moveset)
    while (file - 97).positive? || rank < 8
      file -= 1
      rank += 1
      location = [file.chr, rank].join
      space = board.squares.select { |square| square.location == location }.pop
      break if space.nil?
      break if !space.piece.nil? && space.piece.color == 'white'

      moveset << location
      break if !space.piece.nil? && space.piece.color == 'black'
    end
  end

  def moves_down_and_right(board, file, rank, moveset)
    while (file - 97) < 8 || rank.positive?
      file += 1
      rank -= 1
      location = [file.chr, rank].join
      space = board.squares.select { |square| square.location == location }.pop
      break if space.nil?
      break if !space.piece.nil? && space.piece.color == 'white'

      moveset << location
      break if !space.piece.nil? && space.piece.color == 'black'
    end
  end

  def moves_down_and_left(board, file, rank, moveset)
    while (file - 97).positive? || rank.positive?
      file -= 1
      rank -= 1
      location = [file.chr, rank].join
      space = board.squares.select { |square| square.location == location }.pop
      break if space.nil?
      break if !space.piece.nil? && space.piece.color == 'white'

      moveset << location
      break if !space.piece.nil? && space.piece.color == 'black'
    end
  end
end

# Black Bishop class
class BlackBishop < BlackPiece
  @starting_locations = %w[c8 f8]

  def initialize(location)
    super
    @symbol = "\u265D".encode('utf-8')
  end

  def legal_moves(board)
    file = location.split(//)[0].ord
    rank = location.split(//)[1].to_i
    moveset = []
    moves_up_and_right(board, file, rank, moveset)
    moves_up_and_left(board, file, rank, moveset)
    moves_down_and_right(board, file, rank, moveset)
    moves_down_and_left(board, file, rank, moveset)
    moveset
  end

  def moves_up_and_right(board, file, rank, moveset)
    while (file - 97) < 8 || rank < 8
      file += 1
      rank += 1
      location = [file.chr, rank].join
      space = board.squares.select { |square| square.location == location }.pop
      break if space.nil?
      break if !space.piece.nil? && space.piece.color == 'black'

      moveset << location
      break if !space.piece.nil? && space.piece.color == 'white'
    end
  end

  def moves_up_and_left(board, file, rank, moveset)
    while (file - 97).positive? || rank < 8
      file -= 1
      rank += 1
      location = [file.chr, rank].join
      space = board.squares.select { |square| square.location == location }.pop
      break if space.nil?
      break if !space.piece.nil? && space.piece.color == 'black'

      moveset << location
      break if !space.piece.nil? && space.piece.color == 'white'
    end
  end

  def moves_down_and_right(board, file, rank, moveset)
    while (file - 97) < 8 || rank.positive?
      file += 1
      rank -= 1
      location = [file.chr, rank].join
      space = board.squares.select { |square| square.location == location }.pop
      break if space.nil?
      break if !space.piece.nil? && space.piece.color == 'black'

      moveset << location
      break if !space.piece.nil? && space.piece.color == 'white'
    end
  end

  def moves_down_and_left(board, file, rank, moveset)
    while (file - 97).positive? || rank.positive?
      file -= 1
      rank -= 1
      location = [file.chr, rank].join
      space = board.squares.select { |square| square.location == location }.pop
      break if space.nil?
      break if !space.piece.nil? && space.piece.color == 'black'

      moveset << location
      break if !space.piece.nil? && space.piece.color == 'white'
    end
  end
end

# White Queen class
class WhiteQueen < WhitePiece
  @starting_locations = %w[d1]

  def initialize(location)
    super
    @symbol = "\u2655".encode('utf-8')
  end
end

# Black Queen class
class BlackQueen < BlackPiece
  @starting_locations = %w[d8]

  def initialize(location)
    super
    @symbol = "\u265B".encode('utf-8')
  end
end

# White King class
class WhiteKing < WhitePiece
  @starting_locations = %w[e1]

  def initialize(location)
    super
    @symbol = "\u2654".encode('utf-8')
  end
end

# Black King class
class BlackKing < BlackPiece
  @starting_locations = %w[e8]

  def initialize(location)
    super
    @symbol = "\u265A".encode('utf-8')
  end
end
