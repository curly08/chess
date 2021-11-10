# frozen_string_literal: true

# Horizontal and Vertical Movement module
module HorizontalVerticalMovement
  def add_horizontal_and_vertical_moves(board)
    file = location.split(//)[0].ord
    rank = location.split(//)[1].to_i
    moves_below_rank(board, file, rank)
    moves_above_rank(board, file, rank)
    moves_right_of_file(board, file, rank)
    moves_left_of_file(board, file, rank)
  end

  def moves_above_rank(board, file, rank)
    ((rank + 1)..8).each do |r|
      location = [file.chr, r].join
      space = board.squares.select { |square| square.location == location }.pop
      break if !space.piece.nil? && space.piece.color == color

      moves << location
      break if !space.piece.nil? && space.piece.color != color
    end
  end

  def moves_below_rank(board, file, rank)
    (1..(rank - 1)).reverse_each do |r|
      location = [file.chr, r].join
      space = board.squares.select { |square| square.location == location }.pop
      break if !space.piece.nil? && space.piece.color == color

      moves << location
      break if !space.piece.nil? && space.piece.color != color
    end
  end

  def moves_right_of_file(board, file, rank)
    ((file + 1)..('h'.ord)).each do |f|
      location = [f.chr, rank].join
      space = board.squares.select { |square| square.location == location }.pop
      break if !space.piece.nil? && space.piece.color == color

      moves << location
      break if !space.piece.nil? && space.piece.color != color
    end
  end

  def moves_left_of_file(board, file, rank)
    (('a'.ord)..(file - 1)).reverse_each do |f|
      location = [f.chr, rank].join
      space = board.squares.select { |square| square.location == location }.pop
      break if !space.piece.nil? && space.piece.color == color

      moves << location
      break if !space.piece.nil? && space.piece.color != color
    end
  end
end

# Diagonal movement
module DiagonalMovement
  def add_diagonal_moves(board)
    file = location.split(//)[0].ord
    rank = location.split(//)[1].to_i
    moves_up_and_right(board, file, rank)
    moves_up_and_left(board, file, rank)
    moves_down_and_right(board, file, rank)
    moves_down_and_left(board, file, rank)
  end

  def moves_up_and_right(board, file, rank)
    while (file - 97) < 8 || rank < 8
      file += 1
      rank += 1
      location = [file.chr, rank].join
      space = board.squares.select { |square| square.location == location }.pop
      break if space.nil?
      break if !space.piece.nil? && space.piece.color == color

      moves << location
      break if !space.piece.nil? && space.piece.color != color
    end
  end

  def moves_up_and_left(board, file, rank)
    while (file - 97).positive? || rank < 8
      file -= 1
      rank += 1
      location = [file.chr, rank].join
      space = board.squares.select { |square| square.location == location }.pop
      break if space.nil?
      break if !space.piece.nil? && space.piece.color == color

      moves << location
      break if !space.piece.nil? && space.piece.color != color
    end
  end

  def moves_down_and_right(board, file, rank)
    while (file - 97) < 8 || rank.positive?
      file += 1
      rank -= 1
      location = [file.chr, rank].join
      space = board.squares.select { |square| square.location == location }.pop
      break if space.nil?
      break if !space.piece.nil? && space.piece.color == color

      moves << location
      break if !space.piece.nil? && space.piece.color != color
    end
  end

  def moves_down_and_left(board, file, rank)
    while (file - 97).positive? || rank.positive?
      file -= 1
      rank -= 1
      location = [file.chr, rank].join
      space = board.squares.select { |square| square.location == location }.pop
      break if space.nil?
      break if !space.piece.nil? && space.piece.color == color

      moves << location
      break if !space.piece.nil? && space.piece.color != color
    end
  end
end

# Knight movement
module KnightMovement
  def add_knight_moves(board)
    file = location.split(//)[0].ord
    rank = location.split(//)[1].to_i
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

      moves << move if space.piece.nil? || space.piece.color != color
    end
  end
end

# Pawn movement
module PawnMovement
  def generate_moves(board)
    @moves = []
    file = location.split(//)[0].ord
    rank = location.split(//)[1].to_i
    color == 'white' ? white_pawn_movement(board, file, rank) : black_pawn_movement(board, file, rank)
  end

  def white_pawn_movement(board, file, rank)
    up_one = [file.chr, rank + 1].join
    up_two = [file.chr, rank + 2].join
    capture_left = [(file - 1).chr, rank + 1].join
    capture_left_square = board.squares.select { |square| square.location == capture_left }.pop
    capture_right = [(file + 1).chr, rank + 1].join
    capture_right_square = board.squares.select { |square| square.location == capture_right }.pop
    moves << up_one if board.squares.select { |square| square.location == up_one }.pop.piece.nil?
    moves << up_two if start_locations.include?(location)
    moves << capture_left if !capture_left_square.piece.nil? && capture_left_square.piece.color != color
    moves << capture_right if !capture_right_square.piece.nil? && capture_right_square.piece.color != color
  end

  def black_pawn_movement(board, file, rank)
    down_one = [file.chr, rank - 1].join
    down_two = [file.chr, rank - 2].join
    capture_left = [(file - 1).chr, rank - 1].join
    capture_left_square = board.squares.select { |square| square.location == capture_left }.pop
    capture_right = [(file + 1).chr, rank - 1].join
    capture_right_square = board.squares.select { |square| square.location == capture_right }.pop
    moves << down_one if board.squares.select { |square| square.location == down_one }.pop.piece.nil?
    moves << down_two if start_locations.include?(location)
    moves << capture_left if !capture_left_square.piece.nil? && capture_left_square.piece.color != color
    moves << capture_right if !capture_right_square.piece.nil? && capture_right_square.piece.color != color
  end
end

# King Movement
module KingMovement
  def add_king_moves(board)
    file = location.split(//)[0].ord
    rank = location.split(//)[1].to_i
    [
      [file.chr, rank + 1].join,
      [(file + 1).chr, rank + 1].join,
      [(file + 1).chr, rank].join,
      [(file + 1).chr, rank - 1].join,
      [file.chr, rank - 1].join,
      [(file - 1).chr, rank - 1].join,
      [(file - 1).chr, rank].join,
      [(file - 1).chr, rank + 1].join
    ].each do |move|
      space = board.squares.select { |square| square.location == move }.pop
      next if space.nil?

      moves << move if space.piece.nil? || space.piece.color != color
    end
  end
end
