# frozen_string_literal: true

require_relative '../lib/space'

# board display
class Board
  attr_reader :row_separator, :rank_row, :ranks, :files, :spaces

  def initialize
    @row_separator = '  +---+---+---+---+---+---+---+---+'
    @rank_row = '    a   b   c   d   e   f   g   h'
    @ranks = %w[a b c d e f g h]
    @files = %w[8 7 6 5 4 3 2 1]
    @spaces = make_spaces
  end

  def make_spaces
    arr = []
    files.each do |file|
      ranks.each do |rank|
        arr << Space.new(rank, file)
      end
    end
    arr
  end

  def make_grid
    puts row_separator
    files.each do |file|
      print "#{file} |"
      ranks.each do |rank|
        square = spaces.select { |space| space.location == [rank, file].join }.pop
        print " #{square.data} |"
      end
      puts "\n#{row_separator}"
    end
    puts rank_row
  end
end
