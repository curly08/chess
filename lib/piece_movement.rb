# frozen_string_literal: true

# Horizontal and Vertical Movement module
module HorizontalVerticalMovement
  def horizontal_vertical_moves(board)
    file = location.split(//)[0].ord
    rank = location.split(//)[1].to_i
    moves = []
    moves_below_rank(moves, board, file, rank)
    moves_above_rank(moves, board, file, rank)
    moves_right_of_file(moves, board, file, rank)
    moves_left_of_file(moves, board, file, rank)
    moves
  end

  def moves_above_rank(moves, board, file, rank)
    ((rank + 1)..8).each do |r|
      location = [file.chr, r].join
      space = board.squares.select { |square| square.location == location }.pop
      break if !space.piece.nil? && space.piece.color == color

      moves << location
      break if !space.piece.nil? && space.piece.color != color
    end
  end

  def moves_below_rank(moves, board, file, rank)
    (1..(rank - 1)).reverse_each do |r|
      location = [file.chr, r].join
      space = board.squares.select { |square| square.location == location }.pop
      break if !space.piece.nil? && space.piece.color == color

      moves << location
      break if !space.piece.nil? && space.piece.color != color
    end
  end

  def moves_right_of_file(moves, board, file, rank)
    ((file + 1)..('h'.ord)).each do |f|
      location = [f.chr, rank].join
      space = board.squares.select { |square| square.location == location }.pop
      break if !space.piece.nil? && space.piece.color == color

      moves << location
      break if !space.piece.nil? && space.piece.color != color
    end
  end

  def moves_left_of_file(moves, board, file, rank)
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
  def diagonal_moves(board)
    file = location.split(//)[0].ord
    rank = location.split(//)[1].to_i
    moves = []
    moves_up_and_right(moves, board, file, rank)
    moves_up_and_left(moves, board, file, rank)
    moves_down_and_right(moves, board, file, rank)
    moves_down_and_left(moves, board, file, rank)
    moves
  end

  def moves_up_and_right(moves, board, file, rank)
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

  def moves_up_and_left(moves, board, file, rank)
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

  def moves_down_and_right(moves, board, file, rank)
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

  def moves_down_and_left(moves, board, file, rank)
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
  def knight_moves(board)
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
    ].select do |move|
      space = board.squares.select { |square| square.location == move }.pop
      next if space.nil?

      move if space.piece.nil? || space.piece.color != color
    end
  end
end

# Pawn movement
module PawnMovement
  def pawn_moves(board)
    file = location.split(//)[0].ord
    rank = location.split(//)[1].to_i
    moves = []
    color == 'white' ? white_pawn_movement(moves, board, file, rank) : black_pawn_movement(moves, board, file, rank)
    moves
  end

  def white_pawn_movement(moves, board, file, rank)
    up_one = [file.chr, rank + 1].join
    up_one_square = board.squares.select { |square| square.location == up_one }.pop
    up_two = [file.chr, rank + 2].join
    up_two_square = board.squares.select { |square| square.location == up_two }.pop
    capture_left = [(file - 1).chr, rank + 1].join
    capture_left_square = board.squares.select { |square| square.location == capture_left }.pop
    capture_right = [(file + 1).chr, rank + 1].join
    capture_right_square = board.squares.select { |square| square.location == capture_right }.pop
    moves << up_one if up_one_square.piece.nil?
    moves << up_two if start_locations.include?(location) && up_one_square.piece.nil? && up_two_square.piece.nil?
    moves << capture_left if !capture_left_square.nil? && !capture_left_square.piece.nil? && capture_left_square.piece.color != color
    moves << capture_right if !capture_right_square.nil? && !capture_right_square.piece.nil? && capture_right_square.piece.color != color
  end

  def black_pawn_movement(moves, board, file, rank)
    down_one = [file.chr, rank - 1].join
    down_one_square = board.squares.select { |square| square.location == down_one }.pop
    down_two = [file.chr, rank - 2].join
    down_two_square = board.squares.select { |square| square.location == down_two }.pop
    capture_left = [(file - 1).chr, rank - 1].join
    capture_left_square = board.squares.select { |square| square.location == capture_left }.pop
    capture_right = [(file + 1).chr, rank - 1].join
    capture_right_square = board.squares.select { |square| square.location == capture_right }.pop
    moves << down_one if down_one_square.piece.nil?
    moves << down_two if start_locations.include?(location) && down_one_square.piece.nil? && down_two_square.piece.nil?
    moves << capture_left if !capture_left_square.nil? && !capture_left_square.piece.nil? && capture_left_square.piece.color != color
    moves << capture_right if !capture_right_square.nil? && !capture_right_square.piece.nil? && capture_right_square.piece.color != color
  end
end

# King Movement
module KingMovement
  def king_moves(board)
    file = location.split(//)[0].ord
    rank = location.split(//)[1].to_i
    moves = [
      [file.chr, rank + 1].join,
      [(file + 1).chr, rank + 1].join,
      [(file + 1).chr, rank].join,
      [(file + 1).chr, rank - 1].join,
      [file.chr, rank - 1].join,
      [(file - 1).chr, rank - 1].join,
      [(file - 1).chr, rank].join,
      [(file - 1).chr, rank + 1].join
    ].select do |move|
      space = board.squares.select { |square| square.location == move }.pop
      next if space.nil?

      move if space.piece.nil? || space.piece.color != color
    end
    castle_kingside(file, rank, board, moves) if first_move == true
    castle_queenside(file, rank, board, moves) if first_move == true
    moves
  end

  def castle_moves
    file = location.split(//)[0].ord
    rank = location.split(//)[1].to_i
    [
      [(file + 2).chr, rank].join,
      [(file - 2).chr, rank].join
    ]
  end

  def castle_kingside(file, rank, board, moves)
    kingside_castle = [(file + 2).chr, rank].join
    kingside_rook = board.pieces.select do |piece|
      piece.is_a?(Rook) && piece.color == color && piece.location.include?('h')
    end.pop
    squares_between = [
      board.squares.select { |square| square.location == [(file + 1).chr, rank].join }.pop,
      board.squares.select { |square| square.location == [(file + 2).chr, rank].join }.pop,
    ]
    return unless squares_between_unoccupied?(squares_between) && king_and_rook_first_move?(kingside_rook) && under_attack?(board, squares_between)

    moves << kingside_castle
  end

  def castle_queenside(file, rank, board, moves)
    queenside_castle = [(file - 2).chr, rank].join
    queenside_rook = board.pieces.select do |piece|
      piece.is_a?(Rook) && piece.color == color && piece.location.include?('a')
    end.pop
    squares_between = [
      board.squares.select { |square| square.location == [(file - 1).chr, rank].join }.pop,
      board.squares.select { |square| square.location == [(file - 2).chr, rank].join }.pop,
    ]
    return unless squares_between_unoccupied?(squares_between) && king_and_rook_first_move?(queenside_rook) && under_attack?(board, squares_between)

    moves << queenside_castle
  end

  def squares_between_unoccupied?(squares_between)
    squares_between.all? { |square| square.piece.nil? }
  end

  def king_and_rook_first_move?(rook)
    first_move == true && !rook.nil? && rook.first_move == true
  end

  def under_attack?(board, squares_between)
    squares_between.none? do |square|
      board.pieces.any? do |piece|
        piece.color != color && piece.add_moves(board).include?(square.location)
      end
    end
  end
end
