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

  def user_place_sub
    puts "Please place your submarine,length = 2"
  end

  def user_place_sub_success
    puts "You have successfully placed your submarine!"
  end

  def user_place_cruiser
    puts "Please place your cruiser, length = 3"
  end

  def user_place_cruiser_success
    puts "You have successfully placed your cruiser!"
  end

  def user_place_sub_failure
    puts "Uh oh, it looks like there were one or more errors with your sub placement.  Please try again"
  end

  def user_place_cruiser_failure
    puts "Uh oh, it looks like there were one or more errors with your cruiser placement.  Please try again"
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
    "-------- Computer Board --------"
  end

  def display_player_header
    "--------- Player Board ---------"
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
    "You win. It appears that intelligence doesn't always win. :("
  end

  def computer_wins
     "I have emerged victorious... as always."
  end

end
