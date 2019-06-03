require 'codebreaker/game_statistic'
require 'bundler/setup'
require 'spec_helper'

RSpec.describe GameStatistic do
  let(:stats) { GameStatistic.new('TestStats', 'hard') }

  it 'sets values to instance variables' do
    expect(stats.difficulty).to eq(3)
    expect(stats.attempts_used).to eq(0)
    expect(stats.attempts_total).to eq(5)
    expect(stats.hints_used).to eq(0)
    expect(stats.hints_total).to eq(1)
    expect(stats.name).to eq('TestStats')
  end

  it 'sets easy difficulty parameters' do
    stats.set_easy_difficulty

    expect(stats.difficulty).to eq(1)
    expect(stats.attempts_total).to eq(15)
    expect(stats.hints_total).to eq(2)
  end

  it 'sets middle difficulty parameters' do
    stats.set_middle_difficulty

    expect(stats.difficulty).to eq(2)
    expect(stats.attempts_total).to eq(10)
    expect(stats.hints_total).to eq(1)
  end

  it 'sets hard difficulty parameters' do
    stats.set_hard_difficulty

    expect(stats.difficulty).to eq(3)
    expect(stats.attempts_total).to eq(5)
    expect(stats.hints_total).to eq(1)
  end

  it 'increments attempts' do
    stats.increment_attempts_used
    expect(stats.attempts_used).to eq(1)
  end

  it 'increments hints' do
    stats.increment_hints_used
    expect(stats.hints_used).to eq(1)
  end
  context 'available statistics' do
    let(:stats) { GameStatistic.new('Stats', 'hard') }

    it 'shows attempts available' do
      expect(stats.attempts_available).to eq(5)
    end

    it 'shows hints available' do
      expect(stats.hints_available).to eq(1)
    end
  end
end
