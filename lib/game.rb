require_relative 'board'
require_relative 'cell'
require_relative 'ship'
require_relative 'messages'

class Game
  attr_accessor :player_board, :computer_board, :computer_sub, :computer_cruiser, :player_sub, :player_cruiser, :player_sub_position, :player_cruiser_position, :computer_sub_position, :computer_cruiser_position, :messages, :player_fire, :computer_fire, :player_wins, :computer_wins, :game_over

  def initialize
    @player_board = Board.new
    @computer_board = Board.new
    @computer_sub = Ship.new('sub',2)
    @computer_cruiser = Ship.new('cruiser',3)
    @player_sub = Ship.new('sub',2)
    @player_cruiser = Ship.new('cruiser',3)
    @player_sub_position = []
    @player_cruiser_position = []
    @computer_sub_position = []
    @computer_cruiser_position = []
    @messages = Messages.new
    @player_fire = player_fire
    @computer_fire = @computer_fire
    @player_wins = false
    @computer_wins = false
    @game_over = false
  end


#Methods to render game boards
  def display_computer_board_visible
    puts @computer_board.render
  end

  def display_computer_board_hidden
    puts @computer_board.render(true)
  end

  def display_player_board_visible
    puts @player_board.render
  end

  def display_player_board_hidden
    puts @player_board.render(true)
  end

#Setup computer ships--must revise to add random elements
  def generate_computer_sub_position
      @computer_sub_position = @computer_board.build_row_check_2.sample(1).flatten
  end

  def generate_computer_cruiser_position
    @computer_cruiser_position = @computer_board.build_row_check_3.sample(1).flatten
  end

  def validate_computer_sub_placement
    if @computer_board.valid_placement?(@computer_sub, @computer_sub_position) == true
      generate_computer_cruiser_position
    else
      @computer_sub_position =[]
      @computer_board.row_check = []
      generate_computer_sub_position
    end
  end

  def validate_computer_cruiser_placement
    if @computer_board.valid_placement?(@computer_cruiser, @computer_cruiser_position) == true
      puts 'The computer places its ships..'
    else
      @computer_sub_position =[]
      @computer_board.row_check = []
      generate_computer_cruiser_position
    end
  end

  def place_computer_sub
    @computer_board.place(@computer_sub,@computer_sub_position)
  end

  def place_computer_cruiser
    @computer_board.place(@computer_cruiser,@computer_cruiser_position)
  end

  def place_all_computer_ships
    generate_computer_sub_position
    validate_computer_sub_placement
    generate_computer_cruiser_position
    validate_computer_cruiser_placement
    place_computer_sub
    place_computer_cruiser
    messages.computer_place_ships
    messages.display_computer_header
    display_computer_board_visible
  end


#Setup player_sub ----------------------------------------------------------
  def receive_player_sub_position_1
    messages.user_place_sub
    sub_position_1 = gets.chomp
    if @player_board.valid_coordinate?(sub_position_1) == true
      @player_sub_position << sub_position_1
      receive_player_sub_position_2
    else
      @messages.invalid_coordinates
      receive_player_sub_position_1
    end
  end

  def receive_player_sub_position_2
    #message for player to enter 2nd position here
    sub_input_position_2 = gets.chomp
    if @player_board.valid_coordinate?(sub_input_position_2) == true
       @player_sub_position << sub_input_position_2
       validate_sub_placement
    else
      #add new messages for invalid 2nd coordinate and remove this one
      @messages.invalid_coordinates
      receive_player_sub_position_2
    end
  end

  def validate_sub_placement
    if @player_board.valid_placement?(@player_sub, @player_sub_position) == true
      place_player_sub
      messages.user_place_sub_success
      messages.display_player_header
      display_player_board_hidden
      receive_player_cruiser_position_1
    else
      messages.user_place_sub_failure
      @player_sub_position = []
      @player_board.row_check = []
      receive_player_sub_position_1
    end
  end

  def place_player_sub
    @player_board.place(@player_sub, @player_sub_position)
    @player_board.row_check = []
  end

  def place_all_player_ships
    receive_player_sub_position_1
  end

#Setup player_cruiser ----------------------------------------------------------
def receive_player_cruiser_position_1
  messages.user_place_cruiser
  cruiser_position_1 = gets.chomp
  if @player_board.valid_coordinate?(cruiser_position_1) == true
    @player_cruiser_position << cruiser_position_1
    receive_player_cruiser_position_2
  else
    @messages.invalid_coordinates
    receive_player_cruiser_position_1
  end
end

def receive_player_cruiser_position_2
  #message for player to enter input here
  cruiser_position_2 = gets.chomp
  if @player_board.valid_coordinate?(cruiser_position_2) == true
    @player_cruiser_position << cruiser_position_2
    receive_player_cruiser_position_3
  else
    #add new messages for invalid 2nd coordinate and remove this one
    @messages.invalid_coordinates
    receive_player_cruiser_position_2
  end
end

def receive_player_cruiser_position_3
  #message for player to enter input here
  cruiser_position_3 = gets.chomp
  if @player_board.valid_coordinate?(cruiser_position_3)
    @player_cruiser_position << cruiser_position_3
    validate_cruiser_placement
  else
    #add new messages for invalid 2nd coordinate and remove this one
    @messages.invalid_coordinates
    receive_player_cruiser_position_2
  end
end

def validate_cruiser_placement
  if @player_board.valid_placement?(@player_cruiser, @player_cruiser_position) == true
    place_player_cruiser
    messages.user_place_cruiser_success
    messages.display_player_header
    display_player_board_hidden
  else
    messages.user_place_cruiser_failure
    @player_cruiser_position = []
    @player_board.row_check = []
    receive_player_cruiser_position_1
  end
end

def place_player_cruiser
  @player_board.place(@player_cruiser, @player_cruiser_position)
end

#Battle Methods---------------------------------------------------------------------
#Player Attack Sequence
def player_fire_input
  messages.player_shot
  @player_fire = gets.chomp
  valid_player_shot_input?(@player_fire) && !player_already_fired_on_cell?(@player_fire) ? player_fires(@player_fire) : player_fire_input
end

def valid_player_shot_input?(player_shot)
  @computer_board.valid_coordinate?(player_shot)
end

def player_already_fired_on_cell?(player_shot)
  @computer_board.cells[player_shot].fired_upon?
end

def player_fires(player_shot)
  @computer_board.cells[player_shot].fire_upon
  puts player_fire_result(player_shot)
  if player_fire_result(player_shot) == 'Hit!!'
    puts player_fire_ship_hit_result(player_shot)
  end
end

def player_fire_result(player_shot)
  @computer_board.cells[player_shot].ship.nil? ? 'Miss!' : 'Hit!!'
end

def player_fire_ship_hit_result(player_shot)
  @computer_board.cells[player_shot].ship.health == 0 ? 'The ship was sunk!!' : 'The ship still floats..'
end

#Computer Attack Sequence
def computer_fire_input
  @computer_fire = select_random_coordinate
  @computer_fire = computer_fire.join
  !computer_already_fired_on_cell?(@computer_fire) ? computer_fires(@computer_fire) : computer_fire_input
end

def select_random_coordinate
  @player_board.coordinates.sample(1)
end

def computer_already_fired_on_cell?(computer_shot)
  @player_board.cells[computer_shot].fired_upon?
end

def computer_fires(computer_shot)
  @player_board.cells[computer_shot].fire_upon
  puts computer_fire_result(computer_shot)
  if computer_fire_result(computer_shot) == 'Computer hits you!!'
    puts computer_fire_ship_hit_result(computer_shot)
  end
end

def computer_fire_result(computer_shot)
  @player_board.cells[computer_shot].ship.nil? ? 'Computer misses you!' : 'Computer hits you!!'
end

def computer_fire_ship_hit_result(computer_shot)
  @player_board.cells[computer_shot].ship.health == 0 ? 'Computer sinks your ship!!' : 'Your ship still floats..'
end

#Score Check Methods--------------------------------------------------
def check_players_health
  @player_sub.health + @player_cruiser.health == 0 ? true : 'Your turn!'
end

def check_computers_health
  @computer_sub.health + @computer_cruiser.health == 0 ? true : 'The computer takes a turn..'
end

def check_game_result
  if check_players_health == true
    @computer_wins = true
    @game_over = true
     messages.computer_wins
  elsif check_computers_health == true
    @player_wins = true
    @game_over = true
     messages.player_wins
  end
end

#Cumulative Game Methods-----------------------------------
def initial_setup
  place_all_computer_ships
  place_all_player_ships
end

def looping_gameplay
  player_fire_input
  check_computers_health
  messages.display_computer_header
  display_computer_board_visible
  check_game_result
  computer_fire_input
  check_players_health
  messages.display_player_header
  display_player_board_hidden
  check_game_result
end

def reset_board
  initialize
end

#Main Menu Options----------------------------------------------
def start_game
  messages.welcome
  user_input = gets.upcase.strip
    if user_input == "P"
      initial_setup
      until @game_over == true do looping_gameplay end
      reset_board
      start_game
    elsif user_input =="Q"
      messages.player_quits
      exit
    else
      puts "Invalid option, please try again."
    end
  end
end

game = Game.new
game.start_game

#require 'pry'; binding.pry
