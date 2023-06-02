# frozen_string_literal: true

# Creates and stores information of each player
class Player
  attr_reader :name
  attr_accessor :piece

  def initialize(name)
    @name = name
  end
end
