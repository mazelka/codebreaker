require 'codebreaker/game'
require 'bundler/setup'
require 'spec_helper'

RSpec.describe Game do
  context '#start' do
    let(:game) { Game.new }

    before do
      game.start
    end

    it 'saves secret code' do
      expect(game.instance_variable_get(:@secret_code)).not_to be_empty
    end

    it 'saves 4 numbers secret code' do
      expect(game.instance_variable_get(:@secret_code).size).to eq 4
    end

    it 'saves secret code as Array' do
      expect(game.instance_variable_get(:@secret_code)).to be_kind_of(Array)
    end

    it 'saves secret code with numbers from 1 to 6' do
      expect(game.instance_variable_get(:@secret_code).join).to match(/[1-6]+/)
    end

    it 'create avaliable hints' do
      expect(game.instance_variable_get(:@secret_code)).to match(game.create_hints)
    end

    it 'creates new user and game_statistic instances' do
      expect(game.user).to be_kind_of(User)
      expect(game.stats).to be_kind_of(GameStatistic)
    end

    it 'sets game is not won' do
      expect(game.won).to be false
    end
  end

  context '#break_code' do
    let(:game) { Game.new }

    before do
      game.secret_code = [6, 5, 4, 3]
    end

    it 'compares guess and code' do
      guess = [5, 6, 4, 3]
      expect(game.break_code(guess)).to eq('++--')
      guess = [6, 4, 1, 1]
      expect(game.break_code(guess)).to eq('+-')
      guess = [6, 6, 6, 6]
      expect(game.break_code(guess)).to eq('+')
      guess = [2, 6, 6, 6]
      expect(game.break_code(guess)).to eq('-')
      guess = [6, 5, 4, 4]
      expect(game.break_code(guess)).to eq('+++')
      guess = [0, 1, 1, 0]
      expect(game.break_code(guess)).to eq('')
    end

    it 'wins if code is broken' do
      guess = [6, 5, 4, 3]
      expect(game.break_code(guess)).to eq('++++')
      expect(game.won).to be true
    end
  end

  context '#valid_guess?' do
    let(:game) { Game.new }

    it 'accepts only valid guess' do
      expect(game.valid_guess?('123')).to be false
      expect(game.valid_guess?('0123a')).to be false
      expect(game.valid_guess?('1a23')).to be false
      expect(game.valid_guess?('12827')).to be false
      expect(game.valid_guess?('1234')).to be true
      expect(game.valid_guess?('0123')).to be true
    end
  end

  context '#select_difficulty' do
    let(:game) { Game.new }

    before do
      @stats = GameStatistic.new
      game.stats = @stats
    end

    it 'accepts easy difficulty' do
      allow(game).to receive(:gets).and_return('1')
      expect { game.select_difficulty }.to output(/Easy level is selected/).to_stdout
    end

    it 'accepts medium difficulty' do
      allow(game).to receive(:gets).and_return('2')
      expect { game.select_difficulty }.to output(/Medium level is selected/).to_stdout
    end

    it 'accepts easy difficulty' do
      allow(game).to receive(:gets).and_return('3')
      expect { game.select_difficulty }.to output(/HELL level is selected/).to_stdout
    end

    it 'asks to enter again if not valid' do
      allow(game).to receive(:gets).and_return('0', '1')
      expect { game.select_difficulty }.to output(/This is not valid option/).to_stdout
    end
  end

  context '#get_user_guess' do
    let(:game) { Game.new }

    before do
      @stats = double(GameStatistic.new, all_hints_used?: false, all_attempts_used?: false, increment_hints_used: true)
      game.stats = @stats
    end

    it 'exits game' do
      allow(game).to receive(:gets).and_return('exit')
      expect { game.get_user_guess }.to output(/Goodbye!/).to_stdout
    end
  end

  context 'hints' do
    let(:game) { Game.new }

    before do
      game.start
    end

    it 'shows warning message for hints' do
      expect { game.show_response_for_hint }.to output(/All hints used/).to_stdout
    end

    it 'shows hint' do
      expect { game.show_hint }.to output(/[1-6]/).to_stdout
    end
  end

  context 'incrementing stats' do
    let(:game) { Game.new }

    before do
      game.start
    end

    it 'increments attempts used after valid guess' do
      start_attempts_used = game.stats.attempts_used
      game.process_game_input('1234')
      expect(game.stats.attempts_used).to eq(start_attempts_used + 1)
    end

    it 'increments hints used after showed hint ' do
      start_hints_used = game.stats.hints_used
      game.show_hint
      expect(game.stats.hints_used).to eq(start_hints_used + 1)
    end
  end
end
