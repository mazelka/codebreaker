# require_relative 'interface'
# require_relative 'game'
require_relative '../helpers/statistic'
# require_relative '../helpers/iohelper'
# require 'yaml'

class GameStatistic
  include Statistic
  attr_accessor :difficulty, :attempts_total, :attempts_used, :hints_total, :hints_used, :name

  def initialize
    @name = ''
    @attempts_used = 0
    @hints_used = 0
    @hints_total = 0
    @difficulty = 0
    @attempts_total = 0
  end

  def increment_attempts_used
    @attempts_used += 1
  end

  def all_attempts_used?
    @attempts_used == @attempts_total
  end

  def all_hints_used?
    @hints_used == @hints_total
  end

  def increment_hints_used
    @hints_used += 1
  end

  def set_easy_difficulty
    @difficulty = 1
    @attempts_total = 15
    @hints_total = 2
  end

  def set_medium_difficulty
    @difficulty = 2
    @attempts_total = 10
    @hints_total = 1
  end

  def set_hell_difficulty
    @difficulty = 3
    @attempts_total = 5
    @hints_total = 1
  end
end
