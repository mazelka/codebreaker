require 'codebreaker/game_statistic'
require 'bundler/setup'
require 'spec_helper'

RSpec.describe GameStatistic do
  before(:each) do
    @stats = GameStatistic.new
  end

  it 'sets instance variables to 0' do
    expect(@stats.difficulty).to eq(0)
    expect(@stats.attempts_used).to eq(0)
    expect(@stats.attempts_total).to eq(0)
    expect(@stats.hints_total).to eq(0)
    expect(@stats.difficulty).to eq(0)
    expect(@stats.name).to be_empty
  end

  it 'sets easy difficulty parameters' do
    @stats.set_easy_difficulty

    expect(@stats.difficulty).to eq(1)
    expect(@stats.attempts_total).to eq(15)
    expect(@stats.hints_total).to eq(2)
  end

  it 'sets medium difficulty parameters' do
    @stats.set_medium_difficulty

    expect(@stats.difficulty).to eq(2)
    expect(@stats.attempts_total).to eq(10)
    expect(@stats.hints_total).to eq(1)
  end

  it 'sets hell difficulty parameters' do
    @stats.set_hell_difficulty

    expect(@stats.difficulty).to eq(3)
    expect(@stats.attempts_total).to eq(5)
    expect(@stats.hints_total).to eq(1)
  end

  it 'increments attempts' do
    @stats.increment_attempts_used
    expect(@stats.attempts_used).to eq(1)
  end

  it 'increments hints' do
    @stats.increment_hints_used
    expect(@stats.hints_used).to eq(1)
  end
end
