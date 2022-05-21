require_relative 'board'
require_relative 'cell'
require_relative 'ship'
require_relative 'messages'

class Game
  attr_accessor :player_board, :computer_board, :computer_sub, :computer_cruiser, :player_sub, :player_cruiser, :player_sub_position, :player_cruiser_position, :computer_sub_position, :computer_cruiser_position, :messages, :player_fire, :computer_fire

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
  end


#Render boards
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

#Setup computer ships--must revise to add random elements
  def generate_computer_sub_position
      @computer_sub_position = ['A1','A2'] #dummy position account for overlaps later
  end

  def generate_computer_cruiser_position
    @computer_cruiser_position = ['B1','B2','B4'] #dummy position account for overlaps later
  end

  def place_computer_sub
    @computer_board.place(@computer_sub,@computer_sub_position)
  end

  def place_computer_cruiser
    @computer_board.place(@computer_cruiser,@computer_cruiser_position)
  end

  def computer_sub_placement_error?
    if place_computer_sub == nil
      generate_computer_sub_position
    else
      place_computer_cruiser
    end
  end

  def computer_cruiser_placement_error?
    if place_computer_cruiser == nil
      generate_computer_cruiser_position
    else
      receive_player_sub_position
    end
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
    #start gameplay
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


end
