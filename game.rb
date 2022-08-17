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

  def play
    return unless @remaining_guesses.positive?

    # Following line to be removed
    puts @word
    puts Display.new(@remaining_guesses, @guess)
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
