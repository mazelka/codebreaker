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

  context '#process_game_input' do
    let(:interface) { Interface.new }
    before do
      game = Game.new
      stats = double(GameStatistic.new('Double', 'hard'), increment_attempts_used: true)
      game.instance_variable_set(:@stats, stats)
      game.instance_variable_set(:@secret_code, [1, 2, 3, 4])
      interface.instance_variable_set(:@game, game)
    end

    it 'wins if guess is secret code' do
      expect(interface.process_game_input('1234')).to eq('++++')
      expect(interface.game.won).to be true
    end
  end

  context '#valid_guess?' do
    let(:interface) { Interface.new }

    it 'accepts only valid guess' do
      expect(interface.valid_guess?('123')).to be false
      expect(interface.valid_guess?('0123a')).to be false
      expect(interface.valid_guess?('1a23')).to be false
      expect(interface.valid_guess?('12827')).to be false
      expect(interface.valid_guess?('1234')).to be true
      expect(interface.valid_guess?('0123')).to be true
    end
  end

  context '#get_user_guess' do
    let(:interface) { Interface.new }

    before(:each) do
      game = Game.new
      game.start('Interface', 'hard')
      interface.instance_variable_set(:@game, game)
    end

    it 'shows result of user guess' do
      allow(interface).to receive(:gets).and_return('143', 'exit')
      expect { interface.get_user_guess }.to output(/This in not valid input, try again!/).to_stdout
    end

    it 'shows hint' do
      allow(interface).to receive(:gets).and_return('hint', 'exit')
      expect { interface.get_user_guess }.to output(/Your hint:/).to_stdout
    end

    it 'shows warning message for hints' do
      expect { interface.show_all_hints_used_message }.to output(/All hints used/).to_stdout
    end
  end

  context 'user name' do
    let(:interface) { Interface.new }

    it 'asks for user name' do
      allow(interface).to receive(:gets).and_return('Kasha')
      expect { interface.set_name }.to output(/Nice to meet you Kasha!/).to_stdout
    end

    it 'prompts to enter name again' do
      allow(interface).to receive(:gets).and_return('Ma', 'Mary')
      expect { interface.set_name }.to output(/Name is not valid, try again/).to_stdout
    end

    context '#name_valid?' do
      let(:interface) { Interface.new }

      it 'is not valid if less then 3 symbols' do
        name = 'fo'
        expect(interface.name_valid?(name)).to be_falsey
      end

      it 'is valid if from 3 to 20 symbols' do
        name = 'foo'
        expect(interface.name_valid?(name)).to be_truthy
        name = 'fooooooooooooooooooo'
        expect(interface.name_valid?(name)).to be_truthy
      end

      it 'is not valid if more then 20 symbols' do
        name = 'foooooooooooooooooooo'
        expect(interface.name_valid?(name)).to be_falsey
      end
    end
  end

  context '#select_difficulty' do
    let(:interface) { Interface.new }

    it 'accepts simple difficulty' do
      allow(interface).to receive(:gets).and_return('simple')
      expect { interface.select_difficulty }.to output(/Simple level is selected/).to_stdout
    end

    it 'accepts middle difficulty' do
      allow(interface).to receive(:gets).and_return('MIDDLE')
      expect { interface.select_difficulty }.to output(/Middle level is selected/).to_stdout
    end

    it 'accepts hard difficulty' do
      allow(interface).to receive(:gets).and_return('Hard')
      expect { interface.select_difficulty }.to output(/Hard level is selected/).to_stdout
    end

    it 'asks to enter again if not valid' do
      allow(interface).to receive(:gets).and_return('0', 'Simple')
      expect { interface.select_difficulty }.to output(/This is not valid option/).to_stdout
    end
  end

  context 'end game' do
    let(:interface) { Interface.new }

    it 'shows game over message' do
      expect { interface.show_game_over_message }.to output(/Seems like you used all attempts/).to_stdout
    end

    it 'shows won game message' do
      expect { interface.show_game_won_message }.to output(/Congratulations! you won!/).to_stdout
    end

    it 'exists after end game' do
      allow(interface).to receive(:gets).and_return('exit')
      expect { interface.prompt_to_start_again }.to output("Try again? Enter 'start'\ngoodbye!\n").to_stdout
    end

    context 'statistics' do
      before(:each) do
        game = Game.new
        stats = GameStatistic.new("Statistic#{Random.rand(1..100)}", 'Hard')
        stats.setup_difficulty('hard')
        game.start('Statistic', 'Hard')
        game.instance_variable_set(:@stats, stats)
        interface.instance_variable_set(:@game, game)
      end

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
    end
  end
end
