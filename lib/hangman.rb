class Game
  def initialize(words_source_file)
    @words_source_file = words_source_file
  end

  private

  def select_random_word

  end

  def print_state

  end

  public

  # start a new game
  def new
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