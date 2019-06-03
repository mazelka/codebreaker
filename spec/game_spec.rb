require 'codebreaker/game'
require 'bundler/setup'
require 'spec_helper'

RSpec.describe Game do
  context '#start' do
    let(:game) { Game.new }

    before do
      game.start('test', 'simple')
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

    it 'creates new game_statistic instances' do
      expect(game.stats).to be_kind_of(GameStatistic)
    end

    it 'sets game is not won' do
      expect(game.won).to be false
    end
  end

  context '#break_code' do
    let(:game) { Game.new }

    before do
      game.instance_variable_set(:@secret_code, [6, 5, 4, 3])
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

  context 'hints' do
    let(:game) { Game.new }

    before do
      game.start('Test2', 'simple')
    end

    it 'shows warning message for hints' do
      expect { game.show_all_hints_used_message }.to output(/All hints used/).to_stdout
    end

    it 'generates hint' do
      code = game.instance_variable_get(:@secret_code)
      expect(code.include?(game.generate_hint)).to be true
    end
  end

  context 'incrementing stats' do
    let(:game) { Game.new }

    before do
      game.start('test', 'simple')
    end

    it 'increments attempts used after valid guess' do
      start_attempts_used = game.stats.attempts_used
      game.submit_guess('1234'.chars)
      expect(game.stats.attempts_used).to eq(start_attempts_used + 1)
    end

    it 'increments hints used after showed hint ' do
      start_hints_used = game.stats.hints_used
      game.show_hint
      expect(game.stats.hints_used).to eq(start_hints_used + 1)
    end
  end
end
