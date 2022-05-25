require_relative 'board'
require_relative 'cell'
require_relative 'ship'
require_relative 'messages'

class Game
  attr_accessor :player_sub_position, :player_cruiser_position, :computer_sub_position, :computer_cruiser_position, :messages, :player_fire, :computer_fire,:game_over
  attr_reader :player_board, :computer_board, :computer_sub, :computer_cruiser, :player_sub, :player_cruiser
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
    @game_over = false
  end

#Methods for rendering boards--------------------
  def display_computer_board_visible
    @computer_board.render
  end

  def display_computer_board_hidden
    @computer_board.render(true)
  end

  def display_player_board_visible
     @player_board.render
  end

  def display_player_board_hidden
    @player_board.render(true)
  end

#Setup computer ships
  def generate_computer_sub_position
      @computer_sub_position = @computer_board.random_coordinates_sub_computer.sample(1).flatten!
  end

  def generate_computer_cruiser_position
    @computer_cruiser_position = @computer_board.random_coordinates_cruiser_computer.sample(1).flatten!
  end

  def validate_computer_sub_placement
    if @computer_board.valid_placement?(@computer_sub, @computer_sub_position)
      @computer_sub_position
    else
      generate_computer_sub_position
    end
  end

  def validate_computer_cruiser_placement
    if @computer_board.valid_placement?(@computer_cruiser, @computer_cruiser_position)
      @computer_cruiser_position
    else
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
    place_computer_sub
    generate_computer_cruiser_position
    validate_computer_cruiser_placement
    place_computer_cruiser
    messages.computer_place_ships
    puts messages.display_computer_header
    puts display_computer_board_visible
  end

#Setup player_sub ----------------------------------------------------------
  def receive_player_sub_position_1
    messages.user_place_sub
    sub_position_1 = gets.chomp
    if @player_board.valid_coordinate?(sub_position_1)
      @player_sub_position << sub_position_1
      receive_player_sub_position_2
    else
      @messages.invalid_coordinates
      receive_player_sub_position_1
    end
  end

  def receive_player_sub_position_2
    sub_input_position_2 = gets.chomp
    if @player_board.valid_coordinate?(sub_input_position_2)
       @player_sub_position << sub_input_position_2
    else
      @messages.invalid_coordinates
      receive_player_sub_position_2
    end
  end

  def validate_sub_placement
    if @player_board.valid_placement?(@player_sub, @player_sub_position)
      @player_sub_position
    else
      messages.user_place_sub_failure
      @player_sub_position = []
      receive_player_sub_position_1
    end
  end

  def place_player_sub
    @player_board.place(@player_sub, @player_sub_position)
  end

  def place_all_player_ships
    receive_player_sub_position_1
    validate_sub_placement
    place_player_sub
    messages.user_place_sub_success
    puts messages.display_player_header
    puts display_player_board_hidden
    receive_player_cruiser_position_1
    validate_cruiser_placement
    place_player_cruiser
    puts messages.display_player_header
    puts display_player_board_hidden
    puts "\n"
    puts "Let the game begin.."
  end

#Setup player_cruiser ----------------------------------------------------------
def receive_player_cruiser_position_1
  messages.user_place_cruiser
  cruiser_position_1 = gets.chomp
  if @player_board.valid_coordinate?(cruiser_position_1)
    @player_cruiser_position << cruiser_position_1
    receive_player_cruiser_position_2
  else
    @messages.invalid_coordinates
    receive_player_cruiser_position_1
  end
end

def receive_player_cruiser_position_2
  cruiser_position_2 = gets.chomp
  if @player_board.valid_coordinate?(cruiser_position_2)
    @player_cruiser_position << cruiser_position_2
    receive_player_cruiser_position_3
  else
    @messages.invalid_coordinates
    receive_player_cruiser_position_2
  end
end

def receive_player_cruiser_position_3
  cruiser_position_3 = gets.chomp
  if @player_board.valid_coordinate?(cruiser_position_3)
    @player_cruiser_position << cruiser_position_3
  else
    @messages.invalid_coordinates
    receive_player_cruiser_position_2
  end
end

def validate_cruiser_placement
  if @player_board.valid_placement?(@player_cruiser, @player_cruiser_position)
    @player_cruiser_position
  else
    messages.user_place_cruiser_failure
    @player_cruiser_position = []
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
  if player_fire_result(player_shot) == "\nYou shoot..\nHit!!"
    puts player_fire_ship_hit_result(player_shot)
  end
end

def player_fire_result(player_shot)
  @computer_board.cells[player_shot].ship.nil? ? "\nYou shoot..\nMiss!" : "\nYou shoot..\nHit!!"
end

def player_fire_ship_hit_result(player_shot)
  @computer_board.cells[player_shot].ship.health == 0 ? "\nComputer's ship was sunk!!" : "\nComputer's ship still floats.."
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
  if computer_fire_result(computer_shot) == "\nComputer shoots...\nComputer hits you!!"
    puts computer_fire_ship_hit_result(computer_shot)
  end
end

def computer_fire_result(computer_shot)
  @player_board.cells[computer_shot].ship.nil? ? "\nComputer shoots...\nComputer misses you!!" : "\nComputer shoots...\nComputer hits you!!"
end

def computer_fire_ship_hit_result(computer_shot)
  @player_board.cells[computer_shot].ship.health == 0 ? "\nComputer sinks your ship!!" : "\nYour ship still floats.."
end

#Score Check Methods--------------------------------------------------
def check_players_health
  @player_sub.health == 0 && @player_cruiser.health == 0 ? true : "Your turn!\n"
end

def check_computers_health
  @computer_sub.health == 0 && @computer_cruiser.health == 0 ? true : "The computer takes a turn..\n"
end

def check_game_result
  if check_players_health == true
    @game_over = true
     puts messages.computer_wins
     return
  elsif check_computers_health == true
    @game_over = true
     puts messages.player_wins
  end
end

#Main Menu/Start Game----------------------------------------------
def start_game
  messages.welcome
  user_input = gets.upcase.strip
    if user_input == "P"
      place_all_computer_ships
      place_all_player_ships
      while true
        player_fire_input
        check_computers_health
        puts "\n"
        puts messages.display_computer_header
        puts display_computer_board_visible
        check_game_result
      break if @game_over == true
        computer_fire_input
        check_players_health
        puts "\n"
        puts messages.display_player_header
        puts display_player_board_hidden
        check_game_result
      break if @game_over == true
      end
      initialize
      start_game
    elsif user_input =="Q"
      messages.player_quits
      exit
    else
      puts messages.invalid_input
      start_game
    end
  end
end

#require 'pry';binding.pry
