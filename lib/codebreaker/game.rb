require_relative '../helpers/iohelper'
require_relative 'interface'
require_relative 'game_statistic'

class Game
  include IOHelper
  attr_accessor :stats, :won

  def start(name, difficulty)
    @stats = GameStatistic.new(name, difficulty)
    @won = false
    @secret_code = generate_secret_code
    create_hints
  end

  def break_code(guess)
    if code_is_broken?(guess)
      @won = true
      '++++'
    else
      code_copy = @secret_code.dup
      check_strict_match(guess, code_copy)
      check_existing_match(guess, code_copy)
      compared_result(guess).join.rstrip
    end
  end

  def submit_guess(guess)
    @stats.increment_attempts_used
    break_code(guess)
  end

  def compared_result(guess)
    result = guess.select { |x| ['+', '-'].include?(x) }.sort
    fill_with_spaces(result)
  end

  def fill_with_spaces(result)
    (result + Array.new(4, ' ')).slice(0, 4)
  end

  def check_strict_match(guess, code)
    guess.map.with_index do |number, i|
      if number == @secret_code[i]
        guess[i] = '+'
        index = code.index(number)
        code.delete_at(index)
      end
    end
  end

  def check_existing_match(guess, code)
    guess.map.with_index do |number, i|
      if code.include?(number)
        index = code.index(number)
        guess[i] = '-'
        code.delete_at(index)
      end
    end
  end

  def code_is_broken?(guess)
    guess == @secret_code
  end

  def generate_hint
    hint = @available_hints.sample
    index = @available_hints.index(hint)
    @available_hints.delete_at(index)
    @stats.increment_hints_used
    hint
  end

  def create_hints
    @available_hints = @secret_code.dup
  end

  def generate_secret_code
    4.times.map { Random.rand(1..6) }
  end
end
