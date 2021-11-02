# frozen_string_literal: true

# class for squares on board
class Square
  attr_accessor :data, :piece
  attr_reader :location

  def initialize(rank, file)
    @location = [rank, file].join
    @piece = nil
    @data = ' '
  end
end
