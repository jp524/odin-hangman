require 'csv'

class Game
  def initialize
    @dictionary = []
    @word = ''
    @remaining_guesses = 8
    @guess = ''
    load_dictionary
    select_word
    guess_template
  end

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
    else
      puts "The secret word does not contain '#{input}'.\n\n"
    end
  end

  def play
    # Following line to be removed
    puts @word

    while @remaining_guesses.positive?
      puts Display.new(@remaining_guesses, @guess)
      input_prompt
    end
  end
end

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
