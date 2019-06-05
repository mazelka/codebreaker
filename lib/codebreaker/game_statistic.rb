require_relative '../helpers/statistic'

class GameStatistic
  include Statistic
  attr_accessor :difficulty, :attempts_total, :attempts_used, :hints_total, :hints_used, :name, :date

  def initialize(name, difficulty)
    @name = name
    @attempts_used = 0
    @hints_used = 0
    @date = Time.now.strftime('%Y-%m-%d %H:%M')
    setup_difficulty(difficulty)
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

  def set_middle_difficulty
    @difficulty = 2
    @attempts_total = 10
    @hints_total = 1
  end

  def set_hard_difficulty
    @difficulty = 3
    @attempts_total = 5
    @hints_total = 1
  end

  def setup_difficulty(difficulty)
    case difficulty
    when 'simple'
      set_easy_difficulty
    when 'middle'
      set_middle_difficulty
    when 'hard'
      set_hard_difficulty
    end
  end

  def attempts_available
    @attempts_total - @attempts_used
  end

  def hints_available
    @hints_total - @hints_used
  end
end
