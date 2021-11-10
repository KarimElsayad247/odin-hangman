# class that handles game state
class Game
  def initialize(words_source_file)
    @words_source_file = words_source_file
    @words = File.readlines(@words_source_file)
  end

  private

  def select_random_word
    # @type [String]
    word = ''
    word = @words.sample until word.length.between?(5, 12)
    return word
  end

  def print_state
    puts @remaining_attempts
    puts @secret_word
  end

  public

  def debug
    print_state
  end

  # start a new game
  def new_game
    @remaining_attempts = 6
    @secret_word = select_random_word
  end


  def guess(letter)

  end

  # Idea: save a game in a file ending with .hangman in a ./savedgames dir
  def save_game
  
  end

  # Idea: list all files ending with .hangman in ./savedgames dir
  def load_game
  
  end
end

game = Game.new("5desk.txt")
game.new_game
game.debug