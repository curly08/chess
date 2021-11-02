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
end
