# frozen_string_literal: true

require_relative '../lib/space'

# board display
class Board
  attr_accessor :spaces
  attr_reader :row_separator, :rank_row, :ranks, :files

  def initialize
    @row_separator = '  +---+---+---+---+---+---+---+---+'
    @rank_row = '    a   b   c   d   e   f   g   h'
    @ranks = %w[a b c d e f g h]
    @files = %w[8 7 6 5 4 3 2 1]
    @spaces = []
  end

  def make_grid
    puts row_separator
    files.each do |file|
      print "#{file} |"
      ranks.each do |rank|
        spaces << Space.new(rank, file)
        print " #{spaces.last.data} |"
      end
      puts "\n#{row_separator}"
    end
    puts rank_row
  end
end
