# frozen_string_literal: true

# Starts a game of Tic-Tac-Toe
class TicTacToe
  WINNING_COMBINATIONS = [[0, 1, 2], [0, 3, 6], [0, 4, 8], [1, 4, 7], [2, 4, 6], [2, 5, 8], [3, 4, 5], [6, 7, 8]].freeze

  def initialize
    prep_game
    start
  end

  def prep_game
    puts 'Welcome to Tic-Tac-Toe'

    set_player_names
    set_player_pieces
    sleep 1
    create_board
  end

  def set_player_names
    puts "What's the name of Player 1?"
    @player1 = Player.new(gets.chomp.capitalize)

    puts "What's the name of Player 2?"
    @player2 = Player.new(gets.chomp.capitalize)
  end

  def set_player_pieces
    puts "'X' goes first. #{@player1.name}, would you like to play as 'X' or 'O'?"
    @player1.piece = gets.chomp.capitalize
    a_valid_piece?(@player1.piece)
    @player2.piece = (@player1.piece == 'X' ? 'O' : 'X')
    puts "You chose '#{@player1.piece}', so #{@player2.name} will play as '#{@player2.piece}'"
  end

  def a_valid_piece?(piece)
    until %w[X O].include?(piece)
      puts "Error: Enter either 'X' or 'O'"
      piece = gets.chomp.capitalize
    end
  end

  def create_board
    puts "\nThe numbers 1-9 signify the positions on the board"
    @board = Board.new
    @board.visual
  end

  def start
    @player1.piece == 'X' ? player_turn(@player1) : player_turn(@player2)
  end

  def player_turn(player)
    puts "#{player.name}, where would you like to place your '#{player.piece}'?"
    pick = gets.chomp.to_i
    while @board.values.include?(pick) == false
      puts 'Error: Position invalid, try again'
      pick = gets.chomp.to_i
    end
    adjust_board(player, pick)
    outcome_of_turn(player)
  end

  def adjust_board(player, pick)
    @board.values[pick - 1] = player.piece
    @board.visual
  end

  def outcome_of_turn(player)
    if winner?(player)
      puts "#{player.name} wins!"
      play_again
    elsif its_a_tie
      puts "It's a tie!"
      play_again
    else
      player == @player1 ? player_turn(@player2) : player_turn(@player1)
    end
  end

  def winner?(player)
    WINNING_COMBINATIONS.any? do |combination|
      combination.all? do |position|
        @board.values[position] == player.piece
      end
    end
  end

  def its_a_tie
    [1, 2, 3, 4, 5, 6, 7, 8, 9].all? do |num|
      @board.values.include?(num) == false
    end
  end

  def play_again
    sleep 1
    puts "\nWould you like to play again? [Y/n]"
    response = gets.chomp
    until %w[Y N].include?(response.upcase) || response.empty?
      puts 'Would you like to play again? [Y/n]'
      response = gets.chomp
    end
    restart if response.upcase != 'N'
  end

  def restart
    prep_game
    sleep 1
    start
  end
end

# Creates and stores information for the game board
class Board
  attr_accessor :values

  def initialize
    self.values = [1, 2, 3, 4, 5, 6, 7, 8, 9]
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
    puts "    #{values[0]} | #{values[1]} | #{values[2]} "
  end

  def row2
    puts "    #{values[3]} | #{values[4]} | #{values[5]} "
  end

  def row3
    puts "    #{values[6]} | #{values[7]} | #{values[8]} "
  end
end

# Creates and stores information of each player
class Player
  attr_reader :name
  attr_accessor :piece

  def initialize(name)
    @name = name
  end
end

TicTacToe.new
