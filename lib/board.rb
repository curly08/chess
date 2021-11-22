# frozen_string_literal: true

require_relative '../lib/square'

# board display
class Board
  attr_accessor :pieces, :squares
  attr_reader :row_separator, :rank_row, :ranks, :files

  def initialize
    @row_separator = '  ' + '+---+---+---+---+---+---+---+---+'.on_blue
    @rank_row = '    a   b   c   d   e   f   g   h  '
    @ranks = %w[a b c d e f g h]
    @files = %w[8 7 6 5 4 3 2 1]
    @squares = make_squares
    @pieces = []
  end

  def make_squares
    arr = []
    files.each do |file|
      ranks.each do |rank|
        arr << Square.new(rank, file)
      end
    end
    arr
  end

  def make_grid
    puts row_separator
    files.each do |file|
      print "#{file} " + "|".on_blue
      ranks.each do |rank|
        selected_square = squares.select { |square| square.location == [rank, file].join }.pop
        print " #{selected_square.data} |".on_blue
      end
      puts "\n#{row_separator}"
    end
    puts "#{rank_row}\n"
  end

  def populate_square(piece, piece_location)
    selected_square = squares.select { |square| square.location == piece_location }.pop
    selected_square.piece = piece
    selected_square.data = piece.symbol
    piece.location = piece_location
  end

  def clear_square(location)
    selected_square = squares.select { |square| square.location == location }.pop
    selected_square.piece = nil
    selected_square.data = ' '
  end
end
