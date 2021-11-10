require 'json'

SAVE_FILE_NAME = 'game.hangman'
SAVE_DIR = 'savedgames'

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

  def to_json
    state_string = JSON.dump(
      {
        secret_word: @secret_word,
        guessed_letters: @guessed_letters,
        remaining_attempts: @remaining_attempts,
        remaining_letters_in_word: @remaining_letters_in_word
      }
    )
    return state_string
  end

  def new_game_from_state(rem_att, sec_word, guess_lett, rem_let)
    @remaining_attempts = rem_att
    @secret_word = sec_word
    @guessed_letters = guess_lett
    @remaining_letters_in_word = rem_let
  end

  public

  def print_state
    puts "Remaining attempts: #{@remaining_attempts}"
    puts "Letters remaining in word: #{@remaining_letters_in_word}"
    puts "#{construct_out_string()} \n\n"
  end

  def debug
    p @secret_word
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
  end

  def finished?
    return true if @remaining_attempts.zero? || @remaining_letters_in_word.zero?
  end

  def win?
    return true if @remaining_attempts.positive?
  end

  # Idea: save a game in a file ending with .hangman in a ./savedgames dir
  def save_game
    state_string = to_json()
    Dir.mkdir(SAVE_DIR) unless Dir.exist?(SAVE_DIR)
    File.open("./#{SAVE_DIR}/#{SAVE_FILE_NAME}", 'w') do |file|
      file.write(state_string)
      puts 'Game saved!'
    end
  end

  # Idea: list all files ending with .hangman in ./savedgames dir
  def load_game
    save_file_name = 'game.hangman'
    unless File.exist? "./savedgames/#{save_file_name}"
      puts "save file doesn't exsist!"
      raise StandardError
    end
    save_file = File.open("./#{SAVE_DIR}/#{SAVE_FILE_NAME}", 'r')
    string = save_file.read
    save_file.close
    data = JSON.load string
    new_game_from_state(
      data['remaining_attempts'],
      data['secret_word'],
      data['guessed_letters'],
      data['remaining_letters_in_word']
    )
  end
end

game = Game.new('5desk.txt')

puts ' * At the start of any turn: '
puts ' * Enter 1 to save'
puts ' * Enter 2 to exit [Unsaved progress will be lost]'

print 'Start new game or Load existing game? [S|L]: '
l = gets.chomp
case l
when /[lL]/
  game.load_game
when /[sS]/
  game.new_game
end

while true
  game.print_state
  game.debug
  print 'Enter letter: '
  letter = gets.chomp
  unless letter.length == 1
    puts 'Bad input!'
    next
  end
  case letter
  when /[[:alpha:]]/
    game.guess(letter)
    if game.finished?
      if game.win?
        puts 'You win!'
      else
        puts 'Game over!'
      end
      break
    end
  when '1'
    game.save_game
  when '2'
    puts 'Exiting game'
    break
  end
end
