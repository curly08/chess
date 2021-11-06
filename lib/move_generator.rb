# frozen_string_literal: true

# generates legal moves for the selected piece according to the current board state
class MoveGenerator
  def initialize(board, piece)
    @board = board
    @piece = piece
  end
end
