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
    word = @words.sample.chomp until word.length.between?(5, 12)
    return word
  end

  def guessed?(letter)
    if @guessed_letters.include? letter
      return letter
    else
      return '_'
    end
  end

  # Looking at the secret word, construct an array where non-guessed characters are
  # replaced with underscores
  def construct_out_string
    out_string = @secret_word.map { |c| guessed?(c) }
    return out_string.join(' ')
  end

  def update_state(letter)
    @guessed_letters.push letter
    if @secret_word.include? letter
      puts 'Right!'
      @remaining_letters_in_word -= @secret_word.count(letter)
    else
      puts 'Wrong!'
      @remaining_attempts -= 1
    end
  end

  def print_state
    puts "Remaining attempts: #{@remaining_attempts}"
    puts "Letters remaining in word: #{@remaining_letters_in_word}"
    puts "#{construct_out_string} \n\n"
  end

  public

  def debug
    p @secret_word
    puts @secret_word.join
  end

  # start a new game
  def new_game
    @remaining_attempts = 6
    @secret_word = select_random_word.chars
    @guessed_letters = []
    @remaining_letters_in_word = @secret_word.length
    print_state
  end

  def guess(letter)
    # input should be case insensitive
    letter = letter.downcase

    if @guessed_letters.include? letter
      puts "You already guessed #{letter}"
    else
      update_state(letter)
    end
    print_state
  end

  def finished?
    return true if @remaining_attempts.zero? || @remaining_letters_in_word.zero?
  end

  def win?
    return true if @remaining_attempts.positive?
  end

  # Idea: save a game in a file ending with .hangman in a ./savedgames dir
  def save_game
  
  end

  # Idea: list all files ending with .hangman in ./savedgames dir
  def load_game
  
  end
end

game = Game.new('5desk.txt')
game.new_game
game.debug

while true 
  print 'Enter letter: '
  letter = gets.chomp
  puts 'Bad input!' unless letter.length == 1
  game.guess(letter)
  game.debug
  if game.finished?
    if game.win?
      puts 'You win!'
    else
      puts 'Game over!'
    end
    break
  end
end
