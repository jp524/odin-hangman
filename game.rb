require 'csv'

class Game
  attr_reader :word

  def initialize
    @dictionary = []
    @word = ''
    load_dictionary
    select_word
  end

  def load_dictionary
    contents = CSV.open('google-10000-english-no-swears.txt')

    contents.each do |row|
      @dictionary << row.pop
    end
  end

  def select_word
    @word = @dictionary.sample
    if @word.length < 5 || @word.length > 12
      select_word
    end
    p @word.length
  end

end

game = Game.new
p game.word