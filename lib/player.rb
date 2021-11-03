# frozen_string_literal: true

# players
class Player
  attr_accessor :color, :pieces
  attr_reader :name

  def initialize(name)
    @name = name
    @color = nil
    @pieces = []
  end

  def select_piece
    puts "#{name}, select a piece to move. Ex. \"#{pieces.sample.location}\""
    loop do
      input = gets.chomp
      return pieces.select { |piece| piece.location == input }.pop if pieces.any? { |piece| piece.location == input }

      puts "#{input} is not a valid selection."
    end
  end

  def select_move(piece)
    puts "#{name}, where would you like to move #{piece.location}? Ex. \"#{piece.legal_moves.sample}\""
    loop do
      input = gets.chomp
      return input if piece.legal_moves.include?(input)

      puts "#{input} is not a valid move."
    end
  end
end
