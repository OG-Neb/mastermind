class Player
  def make_guess
    puts "Enter your guess (e.g., red blue green yellow):"
    gets.chomp.split
  end

  def create_secret_code
    puts "Enter your secret code for the computer to guess (e.g., red blue green yellow):"
    gets.chomp.split
  end
end
