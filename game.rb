# frozen_string_literal: false

require 'csv'
require 'yaml'

# Starts game and contains the game's logic
class Game
  def initialize
    @dictionary = []
    @word = ''
    @remaining_guesses = 12
    @guess = ''
    @save_game = false
    load_dictionary
    select_word
    guess_template
  end

  def play
    # Following line to be removed
    puts @word

    while @remaining_guesses.positive? && @save_game == false
      if @guess == @word
        puts "#{@word}\nYou won!"
        break
      end

      puts Display.new(@remaining_guesses, @guess)
      save_prompt
    end

    puts "Better luck next time! The secret word was '#{@word}'." if @remaining_guesses.zero?
  end

  private

  def load_dictionary
    contents = CSV.open('google-10000-english-no-swears.txt')

    contents.each do |row|
      @dictionary << row.pop
    end
  end

  def guess_template
    @word.length.times do
      @guess << '_'
    end
  end

  def select_word
    @word = @dictionary.sample
    select_word if @word.length < 5 || @word.length > 12
  end

  def input_prompt
    puts 'Enter a letter to guess the secret word:'
    input = gets.chomp

    if input.length == 1 && input.match?(/[a-zA-Z]/)
      check_input(input.downcase)
    else
      puts 'Invalid input.'
      input_prompt
    end
  end

  def check_input(input)
    @remaining_guesses -= 1
    if @word.match?(input)
      puts "Match found!\n\n"
      update_guess(input)
    else
      puts "The secret word does not contain '#{input}'.\n\n"
    end
  end

  def update_guess(letter)
    indexes = []
    @word.length.times do |i|
      indexes << i if @word[i] == letter
    end
    indexes.each_entry do |i|
      @guess[i] = letter
    end
  end

  def save_prompt
    puts "\nWould you like to save the game? Type Y for yes, or any other key for no.\n"
    input = gets.chomp.downcase

    if input == 'y'
      save_game
    else
      input_prompt
    end
  end

  def save_game
    @save_game = true
    game_data = YAML.dump({
                            word: @word,
                            guess: @guess,
                            remaining_guesses: @remaining_guesses
                          })

    filename = 'save.yaml'
    File.open(filename, 'w') do |file|
      file.puts game_data
    end
  end
end

# Displays current state of guess and the number of guesses remaining
class Display
  def initialize(remaining_guesses, guess)
    @remaining_guesses = remaining_guesses
    @guess = guess
  end

  def to_s
    "Remaining guesses: #{@remaining_guesses}\n#{@guess}"
  end
end

game = Game.new
game.play
