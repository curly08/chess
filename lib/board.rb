# frozen_string_literal: true

require_relative '../lib/square'

# board display
class Board
  attr_reader :row_separator, :rank_row, :ranks, :files, :squares

  def initialize
    @row_separator = '  +---+---+---+---+---+---+---+---+'
    @rank_row = '    a   b   c   d   e   f   g   h'
    @ranks = %w[a b c d e f g h]
    @files = %w[8 7 6 5 4 3 2 1]
    @squares = make_squares
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
      print "#{file} |"
      ranks.each do |rank|
        selected_square = squares.select { |square| square.location == [rank, file].join }.pop
        print " #{selected_square.data} |"
      end
      puts "\n#{row_separator}"
    end
    puts rank_row
  end
end
