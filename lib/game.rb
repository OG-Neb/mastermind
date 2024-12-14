class Game
  def initialize(role)
    @role = role
    @secret_code = []
    @turns = 12
    @player = Player.new
  end

  def start
    if @role == 'guesser'
      @secret_code = generate_secret_code
      play_as_guesser
    elsif @role == 'creator'
      @secret_code = @player.create_secret_code
      play_as_creator
    else
      puts "Invalid role. Please restart the game."
    end
  end

  private

  def generate_secret_code
    colours = %w[red blue green yellow orange purple]
    colours.sample(4)
  end

  def play_as_guesser
    @turns.times do |turn|
      puts "Turn #{turn + 1} of #{@turns}."
      guess = @player.make_guess
      if valid_guess?(guess)
        feedback = give_feedback(guess)
        puts "Exact matches: #{feedback[:exact]}, Partial matches: #{feedback[:partial]}"
        if feedback[:exact] == 4
          puts "You guessed the code! You win!"
          return
        end
      else
        puts "Invalid guess. Please enter 4 valid colours (e.g., red blue green yellow)."
      end
    end
    puts "You ran out of turns! The secret code was #{@secret_code.join(', ')}"
  end

  def play_as_creator
    puts "Computer will now try to guess your code."
    possible_codes = %w[red blue green yellow orange purple].repeated_permutation(4).to_a

    @turns.times do |turn|
      last_guess = possible_codes.sample
      if last_guess.nil?
        puts "Computer has no valid guesses left! You win!"
        return
      end
      puts "Turn #{turn + 1}/#{@turns}. Computer guesses: #{last_guess.join(', ')}"
      feedback = give_feedback_for_computer(last_guess)
      if feedback[:exact] == 4
        puts "Computer guessed your code: #{last_guess.join(', ')}! Computer wins!"
        return
      end
      possible_codes.select! { |code| consistent_with_feedback?(code, last_guess, feedback) }
    end
    puts "Computer ran out of turns! You win!"
  end

  def valid_guess?(guess)
    colours = %w[red blue green yellow orange purple]
    guess.length == 4 && guess.all? { |colour| colours.include?(colour) }
  end

  def give_feedback(guess)
    exact = exact_matches(guess)
    partial = partial_matches(guess)
    { exact: exact, partial: partial }
  end

  def give_feedback_for_computer(guess)
    exact = guess.each_with_index.count { |colour, index| @secret_code[index] == colour }
    partial = partial_matches_for_code(@secret_code, guess)
    { exact: exact, partial: partial }
  end

  def exact_matches(guess)
    @secret_code.each_with_index.count { |colour, index| colour == guess[index] }
  end

  def partial_matches(guess)
    remaining_secret = []
    remaining_guess = []

    @secret_code.each_with_index do |colour, index|
      if colour != guess[index]
        remaining_secret << colour
        remaining_guess << guess[index]
      end
    end

    remaining_guess.count { |colour| remaining_secret.include?(colour) }
  end

  def consistent_with_feedback?(code, guess, feedback)
    exact = exact_matches_for_code(code, guess)
    partial = partial_matches_for_code(code, guess)
    exact == feedback[:exact] && partial == feedback[:partial]
  end

  def exact_matches_for_code(code, guess)
    code.each_with_index.count { |colour, index| colour == guess[index] }
  end

  def partial_matches_for_code(code, guess)
    remaining_code = []
    remaining_guess = []

    code.each_with_index do |colour, index|
      if colour != guess[index]
        remaining_code << colour
        remaining_guess << guess[index]
      end
    end

    remaining_guess.count { |colour| remaining_code.include?(colour) }
  end
end
