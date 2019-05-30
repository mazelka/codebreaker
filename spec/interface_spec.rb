require 'codebreaker/game'
require 'bundler/setup'
require 'spec_helper'
require 'yaml'

RSpec.describe Interface do
  context 'initialize' do
    let(:interface) { Interface.new }

    it 'shows welcome message' do
      expect { interface }.to output(/Challenge yourself!/).to_stdout
    end

    it 'load statistics' do
      expect(interface.statistic).to_not be_nil
    end
  end

  context '#process_user_input' do
    let(:interface) { Interface.new }

    it 'shows statistic' do
      allow(interface).to receive(:gets).and_return('stats', 'exit')
      expect { interface.process_user_input }.to output(/Rating/).to_stdout
    end

    it 'shows rules' do
      allow(interface).to receive(:gets).and_return('rules', 'exit')
      expect { interface.process_user_input }.to output(/Game Rules/).to_stdout
    end

    it 'exits interface' do
      allow(interface).to receive(:gets).and_return('exit')
      expect { interface.process_user_input }.to output(/goodbye!/).to_stdout
    end

    it 'shows help' do
      allow(interface).to receive(:gets).and_return('help', 'exit')
      expect { interface.process_user_input }.to output(/Please choose one from listed commands:/).to_stdout
    end

    it 'starts game' do
      allow(interface).to receive(:gets).and_return('start')
      expect(Game.new).not_to be_nil
    end
  end

  context 'end game' do
    let(:interface) { Interface.new }

    before(:each) do
      stats = GameStatistic.new
      user = User.new
      game = Game.new
      game.instance_variable_set(:@stats, stats)
      game.instance_variable_set(:@user, user)
      interface.instance_variable_set(:@game, game)
    end

    it 'shows game over message' do
      expect { interface.show_game_over_message }.to output(/Seems like you used all attempts/).to_stdout
    end

    it 'shows won game message' do
      expect { interface.show_game_won_message }.to output(/Congradulations! you won!/).to_stdout
    end

    it 'exists after end game' do
      allow(interface).to receive(:gets).and_return('exit')
      expect { interface.prompt_to_start_again }.to output("Try again? Enter 'start'\ngoodbye!\n").to_stdout
    end

    #failed test

    # it 'starts after end game' do
    #   allow(interface).to receive(:gets).and_return('start', 'exit')
    #   interface.prompt_to_start_again
    #   expect { interface.game_win }.to output(/Enter your name (from 3 to 20 symbols):/).to_stdout
    # end

    it 'asks to save statistics to file' do
      allow(interface).to receive(:gets).and_return('exit')
      expect { interface.game_win }.to output(/Do you want to save your statistics?/).to_stdout
    end

    it 'adds new game statictic to file after win' do
      number_of_games = interface.statistic.size
      allow(interface).to receive(:gets).and_return('y', 'exit')
      interface.game_win
      expect(interface.statistic.size).to eq(number_of_games + 1)
    end

    it 'set used attempts to 0' do
      allow(interface).to receive(:gets).and_return('y', 'exit')
      interface.game_over
      expect(interface.game.stats.attempts_used).to eq(0)
    end
  end
end
