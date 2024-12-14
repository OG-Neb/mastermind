require_relative 'lib/game'
require_relative 'lib/player'

# Main script
puts "Welcome to Mastermind!"
puts "Do you want to be the code creator or guesser? (Enter 'creator' or 'guesser')"
role = gets.chomp.downcase

game = Game.new(role)
game.start