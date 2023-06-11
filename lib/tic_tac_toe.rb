# frozen_string_literal: true

require_relative 'board'
require_relative 'player'

# Starts a game of Tic-Tac-Toe
class TicTacToe
  WINNING_COMBINATIONS = [[0, 1, 2], [0, 3, 6], [0, 4, 8], [1, 4, 7],
                          [2, 4, 6], [2, 5, 8], [3, 4, 5], [6, 7, 8]].freeze

  def prep_game
    puts 'Welcome to Tic-Tac-Toe'

    @player1 = new_player(1)
    @player2 = new_player(2)
    set_player_pieces
    sleep 1
    create_board.visual
  end

  def new_player(num)
    puts "What's the name of Player #{num}?"
    Player.new(gets.chomp)
  end

  def set_player_pieces
    puts "'X' goes first. #{@player1.name}, would you like to play as 'X' or 'O'?"
    @player1.change_piece(player1_piece)
    @player2.change_piece(player2_piece)
    puts "You chose '#{@player1.piece}', so #{@player2.name} will play as '#{@player2.piece}'"
  end

  def player1_piece
    piece = gets.chomp.capitalize
    until %w[X O].include?(piece)
      puts "Error: Enter either 'X' or 'O'"
      piece = gets.chomp.capitalize
    end
    piece
  end

  def player2_piece
    @player1.piece == 'X' ? 'O' : 'X'
  end

  def create_board
    puts "\nThe numbers 1-9 signify the positions on the board"
    @board = Board.new
  end

  def start
    @player1.piece == 'X' ? player_turn(@player1) : player_turn(@player2)
  end

  def player_turn(player)
    puts "#{player.name}, where would you like to place your '#{player.piece}'?"
    adjust_board(player.piece, pick)
    outcome_of_turn(player)
  end

  def pick
    pick = gets.chomp.to_i
    while @board.values.include?(pick) == false
      puts 'Error: Position invalid, try again'
      pick = gets.chomp.to_i
    end
    pick
  end

  def adjust_board(piece, pick)
    @board.change_value(piece, pick)
    @board.visual
  end

  def outcome_of_turn(player)
    if winner?(player)
      puts "#{player.name} wins!"
      new_game
    elsif board_full?(@board)
      puts "It's a tie!"
      new_game
    else
      player_turn(player == @player1 ? @player2 : @player1)
    end
  end

  def winner?(player)
    WINNING_COMBINATIONS.any? do |combination|
      combination.all? do |position|
        @board.values[position] == player.piece
      end
    end
  end

  def board_full?(board)
    [1, 2, 3, 4, 5, 6, 7, 8, 9].all? do |num|
      board.values.include?(num) == false
    end
  end

  def new_game
    restart if play_again?
  end

  def restart
    prep_game
    sleep 1
    start
  end

  def play_again?
    sleep 1
    puts "\nWould you like to play again? [Y/n]"
    response = gets.chomp.to_s
    until %w[Y N].include?(response.upcase) || response.empty?
      puts 'Would you like to play again? [Y/n]'
      response = gets.chomp.to_s
    end
    response.upcase != 'N'
  end
end
