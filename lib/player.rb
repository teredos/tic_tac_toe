# frozen_string_literal: true

# Creates and stores information of each player
class Player
  attr_reader :name, :piece

  def initialize(name)
    @name = name
  end

  def change_piece(piece)
    @piece = piece
  end
end
