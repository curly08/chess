# frozen_string_literal: true

# class for spaces on board
class Space
  attr_accessor :data, :piece
  attr_reader :location

  def initialize(rank, file)
    @location = [rank, file].join
    @piece = nil
    @data = ' '
  end
end
