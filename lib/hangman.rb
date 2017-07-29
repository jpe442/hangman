class Hangman
  attr_reader :guesser, :referee
  attr_accessor :board

  def initialize(options = {})
    default = {
        guesser: HumanPlayer.new("human"),
        referee: ComputerPlayer.new
        }
    
    options = default.merge(options)
      
    @guesser = options[:guesser]
    @referee = options[:referee]
      
  end
  
  def setup
   # tells the referee to choose a secret word
   # tells the guesser the length of the secret word
   # sets the board to be the same length as the secret length
   
   @secret_length = @referee.pick_secret_word
   @secret_word = @referee.secret_word
   @guesser.register_secret_length(@secret_length)
      
   @board = ["_"] * @secret_length
   
  end
    
  def take_turn
   # asks the guesser for a guess
   # has the referee check the guesser's guess
   # updates the board
   # has the guesser handle the referee's response
      print @board.join(" ")
      guess = @guesser.guess
      update = @referee.check_guess(guess)
      update_board(update, guess)
      @guesser.handle_response(update, guess)
      
  end
   
  def play
    count = 0
    until count == 10 || !@board.include?("_")
      take_turn
      count += 1
    end
      
    if count == 10
      puts "you have ran out of guesses"
      puts "the secret word was #{referee.secret_word}"
    else
      puts "congratulations you guessed the secret word!"
    end
      
  end
    
  def update_board(arr, guess)
    arr.each do |el|
      @board[el] = guess
    end
  end
  
end

class HumanPlayer
  
  def initialize(name)
    @name = name
  end

  def guess
    puts "please guess a letter"
    guess = gets.chomp
  end
  
  def register_secret_length(length)
    puts "the secret word has #{length} letters in it..."
  end
    
  def handle_response(update, guess)
    if update.length > 0
      "#{guess} occurs #{update.length} times..."
    else
      "unfortunately, the letter #{guess} does not occur in the secret word"
    end
  end
  
end

class ComputerPlayer

attr_accessor :secret_word
    
  def initialize(dictionary = File.readlines("dictionary.txt"))
    @dictionary = dictionary
  end

  def pick_secret_word
    # returns length of a word in the dictionary
    @secret_word = @dictionary.sample.strip
    @secret_word.length
  end

  def check_guess(letter)
    # accepts a letter as an argument
    # returns the indicies of the found letters
    # handles an incorrect guess
    guess_idx = []
    @secret_word.chars.each_index do |i|
      guess_idx << i if letter == @secret_word[i]
    end
    guess_idx

  end

end

new_game = Hangman.new
new_game.setup
new_game.play