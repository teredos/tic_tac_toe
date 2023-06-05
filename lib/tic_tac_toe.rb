# frozen_string_literal: true

require_relative 'board'
require_relative 'player'

# Starts a game of Tic-Tac-Toe
class TicTacToe
  WINNING_COMBINATIONS = [[0, 1, 2], [0, 3, 6], [0, 4, 8], [1, 4, 7], [2, 4, 6], [2, 5, 8], [3, 4, 5], [6, 7, 8]].freeze

  def prep_game
    puts 'Welcome to Tic-Tac-Toe'

    @player1 = new_player(1)
    @player2 = new_player(2)
    set_player_pieces
    sleep 1
    create_board
  end

  def new_player(num)
    puts "What's the name of Player #{num}?"
    Player.new(gets.chomp)
  end

  def set_player_pieces
    puts "'X' goes first. #{@player1.name}, would you like to play as 'X' or 'O'?"
    @player1.piece = gets.chomp.capitalize
    confirm_player1_piece
    set_player2_piece
    puts "You chose '#{@player1.piece}', so #{@player2.name} will play as '#{@player2.piece}'"
  end

  def confirm_player1_piece
    until %w[X O].include?(@player1.piece)
      puts "Error: Enter either 'X' or 'O'"
      @player1.piece = gets.chomp.capitalize
    end
  end

  def set_player2_piece
    @player2.piece = (@player1.piece == 'X' ? 'O' : 'X')
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
