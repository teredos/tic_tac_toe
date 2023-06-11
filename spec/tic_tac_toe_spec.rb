# frozen_string_literal: true

require_relative '../lib/tic_tac_toe'

describe TicTacToe do
  let(:game) { described_class.new }
  describe '#new_player' do
    context 'when a value is input' do
      before(:each) do
        @name = 'Lewis'
        allow(game).to receive(:puts)
        allow(game).to receive_message_chain(:gets, :chomp).and_return(@name)
        @value = 1
        @method = game.new_player(@value)
      end
      it 'returns a new instance of Player' do
        expect(@method).to be_a Player
      end
      it "assigns value as new Player's name" do
        expect(@method.name).to eq(@name)
      end
    end
  end

  describe '#player1_piece' do
    context 'when chosen piece is valid' do
      before(:each) do
        allow(game).to receive_message_chain(:gets, :chomp,
                                             :capitalize).and_return('X')
      end
      it "doesn't output an error message" do
        expect(game).not_to receive(:puts)
        game.player1_piece
      end
      it 'returns a valid piece' do
        expect(game.player1_piece).to eq('X')
      end
    end
    context 'when chosen piece for player is invalid once, then valid' do
      before(:each) do
        allow(game).to receive_message_chain(:gets, :chomp, :capitalize).and_return(
          42, 'O'
        )
        allow(game).to receive(:puts)
      end
      it 'outputs an error message once' do
        expect(game).to receive(:puts).once
        game.player1_piece
      end
      it 'returns a valid piece' do
        expect(game.player1_piece).to eq('O')
      end
    end
    context 'when chosen piece for player is invalid thrice, then valid' do
      before(:each) do
        allow(game).to receive_message_chain(:gets, :chomp, :capitalize).and_return(
          100, 'the', :hello, 'X'
        )
        allow(game).to receive(:puts)
      end
      it 'outputs an error message thrice' do
        expect(game).to receive(:puts).thrice
        game.player1_piece
      end
      it 'returns a valid piece' do
        expect(game.player1_piece).to eq('X')
      end
    end
  end

  describe '#player2_piece' do
    context "when player 1's piece is 'X'" do
      let(:player1) { instance_double(Player, piece: 'X') }
      it "returns 'O'" do
        game.instance_variable_set(:@player1, player1)
        expect(game.player2_piece).to eq('O')
      end
    end
    context "when player 1's piece is 'O'" do
      let(:player1) { instance_double(Player, piece: 'O') }
      it "returns 'X'" do
        game.instance_variable_set(:@player1, player1)
        expect(game.player2_piece).to eq('X')
      end
    end
  end

  describe '#create_board' do
    it 'returns an instance of Board' do
      allow(game).to receive(:puts)
      expect(game.create_board).to be_a Board
    end
  end

  describe '#start' do
    context "when player 1's piece is 'X'" do
      it 'returns player 1 turn' do
        game.instance_variable_set(:@player1,
                                   instance_double(Player, piece: 'X'))
        expect(game).to receive(:player_turn).with(game.instance_variable_get(:@player1))
        game.start
      end
    end
    context "when player 1's piece is 'O'" do
      it 'returns player 2 turn' do
        game.instance_variable_set(:@player1,
                                   instance_double(Player, piece: 'O'))
        game.instance_variable_set(:@player2,
                                   instance_double(Player, piece: 'X'))
        expect(game).to receive(:player_turn).with(game.instance_variable_get(:@player2))
        game.start
      end
    end
  end

  describe '#pick' do
    let(:board) do
      instance_double(Board, values: ['X', 'O', 'X', 'O', 'O', 6, 'X', 'X', 9])
    end
    before(:each) do
      game.instance_variable_set(:@board, board)
    end
    context 'when position pick is valid' do
      before(:each) do
        allow(game).to receive_message_chain(:gets, :chomp, :to_i).and_return(6)
      end
      it 'does not output an error' do
        expect(game).not_to receive(:puts)
        game.pick
      end
      it 'returns a valid position pick' do
        expect(game.pick).to eq(6)
      end
    end
    context 'when position pick is invalid once, then valid' do
      before(:each) do
        allow(game).to receive_message_chain(:gets, :chomp, :to_i).and_return(
          4, 9
        )
        allow(game).to receive(:puts)
      end
      it 'outputs an error once' do
        expect(game).to receive(:puts).once
        game.pick
      end
      it 'returns a valid position pick' do
        expect(game.pick).to eq(9)
      end
    end
    context 'when position pick is invalid thrice, then valid' do
      before(:each) do
        allow(game).to receive_message_chain(:gets, :chomp, :to_i).and_return(
          'three', 4, :five, 6
        )
        allow(game).to receive(:puts)
      end
      it 'outputs an error three times' do
        expect(game).to receive(:puts).thrice
        game.pick
      end
      it 'returns a valid position pick' do
        expect(game.pick).to eq(6)
      end
    end
  end

  describe '#outcome_of_turn' do
    let(:player) { instance_double(Player) }
    before(:each) do
      allow(player).to receive(:name)
      allow(game).to receive(:puts)
      allow(game).to receive(:winner?)
      allow(game).to receive(:board_full?)
    end
    context 'when the input player has won' do
      it 'returns new_game method' do
        allow(game).to receive(:winner?).and_return(true)
        expect(game).to receive(:new_game)
        game.outcome_of_turn(player)
      end
    end
    context 'when the players have tied' do
      it 'returns new_game method' do
        allow(game).to receive(:board_full?).and_return(true)
        expect(game).to receive(:new_game)
        game.outcome_of_turn(player)
      end
    end
    context 'if the turn ends with no game conclusion' do
      it 'returns next turn' do
        expect(game).to receive(:player_turn)
        game.outcome_of_turn(player)
      end
    end
  end

  describe '#winner?' do
    let(:player) { double('Player', piece: 'X') }
    context 'when player has a winning combination' do
      let(:board) { double('Board', values: ['X', 'X', 'X', 4, 5, 6, 7, 8, 9]) }
      it 'returns true' do
        game.instance_variable_set(:@board, board)
        expect(game.winner?(player)).to eq(true)
      end
    end
    context "when player doesn't have a winning combination" do
      let(:board) { double('Board', values: [1, 2, 'X', 'X', 'X', 6, 7, 8, 9]) }
      it 'returns false' do
        game.instance_variable_set(:@board, board)
        expect(game.winner?(player)).to eq(false)
      end
    end
  end

  describe '#board_full?' do
    context 'when every board position includes a piece' do
      let(:board) do
        double('Board', values: %w[X X O O O X X X O])
      end
      it 'returns true' do
        expect(game.board_full?(board)).to eq(true)
      end
    end
    context 'when only three board positions include a piece' do
      let(:board) { double('Board', values: ['X', 'O', 'X', 4, 5, 6, 7, 8, 9]) }
      it 'returns false' do
        expect(game.board_full?(board)).to eq(false)
      end
    end
  end

  describe '#play_again?' do
    before(:each) do
      allow(game).to receive(:sleep)
      allow(game).to receive(:puts).with("\nWould you like to play again? [Y/n]")
    end
    context "when user inputs 'Y'" do
      it 'returns true' do
        allow(game).to receive_message_chain(:gets, :chomp,
                                             :to_s).and_return('Y')
        expect(game.play_again?).to eq(true)
      end
    end
    context "when user inputs 'N'" do
      it 'returns false' do
        allow(game).to receive_message_chain(:gets, :chomp,
                                             :to_s).and_return('N')
        expect(game.play_again?).to eq(false)
      end
    end
    context 'when user input is invalid once, then valid' do
      it 'repeats the question once' do
        question = 'Would you like to play again? [Y/n]'
        allow(game).to receive_message_chain(:gets, :chomp, :to_s).and_return(
          '21', 'Y'
        )
        expect(game).to receive(:puts).with(question).once
        game.play_again?
      end
    end
    context 'when user input is invalid thrice, then valid' do
      it 'repeats the question thrice' do
        question = 'Would you like to play again? [Y/n]'
        allow(game).to receive_message_chain(:gets, :chomp, :to_s).and_return(
          'one', '2', 'three', 'N'
        )
        expect(game).to receive(:puts).with(question).thrice
        game.play_again?
      end
    end
  end
end
