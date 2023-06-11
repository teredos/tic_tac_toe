# frozen_string_literal: true

# Creates and stores information for the game board
class Board
  attr_reader :values

  def initialize
    @values = [1, 2, 3, 4, 5, 6, 7, 8, 9]
  end

  def change_value(val, pos)
    @values[pos - 1] = val
  end

  def visual
    puts ''
    row1
    puts '   ---+---+---'
    row2
    puts '   ---+---+---'
    row3
    puts ''
  end

  def row1
    puts "    #{@values[0]} | #{@values[1]} | #{@values[2]} "
  end

  def row2
    puts "    #{@values[3]} | #{@values[4]} | #{@values[5]} "
  end

  def row3
    puts "    #{@values[6]} | #{@values[7]} | #{@values[8]} "
  end
end
