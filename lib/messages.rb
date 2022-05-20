require './lib/ship'
require './lib/cell'
require './lib/board'

class Messages

  def welcome
    puts "*** Welcome to BATTLESHIP ***"
    puts "Would you like to play a game?"
    puts "Enter p to play or q to quit."
  end

  def player_quits
    puts "You have chosen to quit the game."
    puts "*** Goodbye ***"
  end

  def computer_place_ships
    puts "Computer has placed its ships."
  end

  def user_place_ships
    puts "Please place your ships"
  end

  def submarine_placement
    puts "Enter the coordinates for your submarine"
  end

  def cruiser_placement
    puts "Enter the coordinates for your cruiser"
  end

  def invalid_coordinates
    puts "Those coordinates are invalid"
    puts "Coordinates should be input"
    puts "left to right, top to bottom."
  end

  def display_computer_header
    puts "-------- Computer Board --------"
  end

  def display_player_header
    puts "--------- Player Board ---------"
  end

  def player_shot
  puts "Enter the coordinates for your shot"
  print ">>"
  end

  def incorrect_shot
    puts "That shot is incorrect."
    puts "Please try again."
  end

  def player_wins
    puts "You win."
    puts "It appears that intelligence doesn't"
    puts "always win. :("
  end

  def computer_wins
    puts "I have emerged victorious... as always."
  end

end
