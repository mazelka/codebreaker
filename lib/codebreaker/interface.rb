require_relative '../helpers/iohelper'
require_relative '../helpers/statistic'
require_relative 'game'
require_relative '../helpers/user'
require_relative 'game_statistic'

class Interface
  include IOHelper
  include Statistic
  include User

  attr_accessor :statistic, :game, :stats, :user

  def initialize
    @statistic = [] unless load_statistic
    show_welcome
  end

  def process_user_input
    while (input = gets.chomp)
      case input
      when 'rules'
        show_rules
      when 'stats'
        show_stats
      when 'start'
        start_game_process
        break
      when 'exit'
        puts 'goodbye!'
        break
      else
        show_help
      end
      'Goodbye!'
    end
  end

  def start_game_process
    @game = Game.new
    name = set_name
    difficulty = select_difficulty
    @game.start(name, difficulty)
    get_user_guess
    game_win if @game.won
    game_over if @game.stats.all_attempts_used?
  end

  def game_over
    show_game_over_message
    prompt_to_start_again
  end

  def game_win
    show_game_won_message
    add_statistics_to_file if save_statistics?
    prompt_to_start_again
  end

  def save_statistics?
    puts "Do you want to save your statistics? enter 'y' if yes:"
    input = gets.chomp
    input == 'y'
  end

  def show_game_over_message
    puts 'Seems like you used all attempts ;('
  end

  def show_game_won_message
    puts 'Congratulations! you won!'
  end

  def prompt_to_start_again
    puts "Try again? Enter 'start'"
    process_user_input
  end

  def select_difficulty
    show_hints_help
    while (input = gets.chomp)
      case input.downcase
      when 'simple'
        puts 'Simple level is selected'
        break
      when 'middle'
        puts 'Middle level is selected'
        break
      when 'hard'
        puts 'Hard level is selected'
        break
      else
        puts 'This is not valid option :('
        show_hints_help
      end
    end
    input.downcase
  end

  def get_user_guess
    until @game.stats.all_attempts_used?
      puts 'Enter your guess:'
      input = gets.chomp
      case input
      when 'exit'
        break puts 'Goodbye!'
      when 'hint'
        @game.stats.all_hints_used? ? show_all_hints_used_message : show_hint
      else
        p process_game_input(input)
        break if @game.won
      end
    end
  end

  def process_game_input(input)
    if valid_guess?(input)
      input_in_array = input.split('').map(&:to_i)
      @game.submit_guess(input_in_array)
    else
      'This in not valid input, try again!'
    end
  end

  def show_hint
    hint = @game.generate_hint
    puts "Your hint: #{hint}"
  end

  def show_all_hints_used_message
    puts 'All hints used ;(  try to guess!'
  end

  def valid_guess?(guess)
    guess == guess.gsub(/[a-zA-Z]/, '') && guess.size == 4
  end
end
