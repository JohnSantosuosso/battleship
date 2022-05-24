require './lib/game.rb'
require './lib/board.rb'
require './lib/cell.rb'
require './lib/ship.rb'
require './lib/messages.rb'

RSpec.describe Game do
  before do
    @game = Game.new
  end

  describe '#initialize' do
    it 'is an instance of game' do
      expect(@game).to be_an_instance_of(Game)
    end

    it 'it has boards by default' do
      expect(@game.player_board).to be_an_instance_of(Board)
      expect(@game.computer_board).to be_an_instance_of(Board)
    end

    it 'it has no ship position by default' do

      expect(@game.player_sub_position).to eq([])
    end
  end

  describe '#generate_computer_sub_position' do
    it 'returns an array' do
        expect(@game.generate_computer_sub_position).to be_an(Array)
    end
    it 'returns two coordinates' do
      expect(@game.generate_computer_sub_position.count).to eq(2)
    end
  end

  describe 'generate_computer_cruiser_position' do
    it 'returns an array' do
        expect(@game.generate_computer_cruiser_position).to be_an(Array)
    end
    it 'returns two coordinates' do
      expect(@game.generate_computer_cruiser_position.count).to eq(3)
    end
  end

  describe '#validate_computer_sub_placement' do
    it 'valid sub placement' do
      expect(@game.validate_computer_sub_placement.count).to eq(2)
    end
  end

  describe '#validate_computer_cruiser_placement' do
    it 'valid cruiser placement' do
      expect(@game.validate_computer_cruiser_placement.count). to eq(3)
    end
  end

  describe '#boards rendering' do
    it 'can display a computer board with hidden ships' do
      expect(@game.display_computer_board_visible). to eq("  1 2 3 4\nA . . . .\nB . . . .\nC . . . .\nD . . . .\n")
    end

    it 'displays a player board with no ships placed' do
      expect(@game.display_player_board_visible). to eq("  1 2 3 4\nA . . . .\nB . . . .\nC . . . .\nD . . . .\n")
    end

    it 'displays a player board correctly when players sub is placed' do
      @game.player_board.place(Ship.new('sub',2),['A1','A2'])
      expect(@game.display_player_board_hidden). to eq("  1 2 3 4\nA S S . .\nB . . . .\nC . . . .\nD . . . .\n")
    end

    it 'displays a player board correctly when players cruiser is placed' do
      @game.player_board.place(Ship.new('cruiser',3),['A1','A2','A3'])
      expect(@game.display_player_board_hidden). to eq("  1 2 3 4\nA S S S .\nB . . . .\nC . . . .\nD . . . .\n")
    end

    it 'displays a computer board correctly when computers sub is placed' do
      @game.computer_board.place(Ship.new('sub',2),['A1','A2'])
      expect(@game.display_computer_board_hidden). to eq("  1 2 3 4\nA S S . .\nB . . . .\nC . . . .\nD . . . .\n")
    end

    it 'displays a computer board correctly when computers cruiser is placed' do
      @game.computer_board.place(Ship.new('cruiser',3),['A1','A2','A3'])
      expect(@game.display_computer_board_hidden). to eq("  1 2 3 4\nA S S S .\nB . . . .\nC . . . .\nD . . . .\n")
    end

  end

  describe '#boards render after attack sequence' do
    it 'displays a computer board after computers ship is hit' do
      @game.computer_board.place(Ship.new('cruiser',3),['A1','A2','A3'])
      @game.player_fires('A1')
      expect(@game.player_fire_result('A1')).to eq("Hit!!")
      expect(@game.player_fire_ship_hit_result('A1')).to eq('The ship still floats..')
      expect(@game.display_computer_board_hidden). to eq("  1 2 3 4\nA H S S .\nB . . . .\nC . . . .\nD . . . .\n")
      expect(@game.display_computer_board_visible). to eq("  1 2 3 4\nA H . . .\nB . . . .\nC . . . .\nD . . . .\n")
    end

    it 'displays a computer board after a miss' do
      @game.computer_board.place(Ship.new('cruiser',3),['A1','A2','A3'])
      @game.player_fires('B2')
      expect(@game.player_fire_result('B2')).to eq("Miss!")
      expect(@game.display_computer_board_hidden). to eq("  1 2 3 4\nA S S S .\nB . M . .\nC . . . .\nD . . . .\n")
      expect(@game.display_computer_board_visible). to eq("  1 2 3 4\nA . . . .\nB . M . .\nC . . . .\nD . . . .\n")
    end

    it 'displays a players board after a players ship is hit' do
      @game.player_board.place(Ship.new('cruiser',3),['A1','A2','A3'])
      @game.computer_fires('A1')
      expect(@game.computer_fire_result('A1')).to eq('Computer hits you!!')
      expect(@game.display_player_board_hidden). to eq("  1 2 3 4\nA H S S .\nB . . . .\nC . . . .\nD . . . .\n")
      expect(@game.display_player_board_visible). to eq("  1 2 3 4\nA H . . .\nB . . . .\nC . . . .\nD . . . .\n")
    end

    it 'displays a players board after a players ship is missed' do
      @game.player_board.place(Ship.new('cruiser',3),['A1','A2','A3'])
      @game.computer_fires('A4')
      expect(@game.computer_fire_result('A4')).to eq("Computer misses you!")
      expect(@game.display_player_board_hidden). to eq("  1 2 3 4\nA S S S M\nB . . . .\nC . . . .\nD . . . .\n")
      expect(@game.display_player_board_visible). to eq("  1 2 3 4\nA . . . M\nB . . . .\nC . . . .\nD . . . .\n")
    end

    it 'displays a computer board after computers ship is sunk' do
      @game.computer_board.place(Ship.new('sub',2),['A1','A2'])
      @game.player_fires('A1')
      expect(@game.player_fire_ship_hit_result('A1')).to eq('The ship still floats..')
      expect(@game.player_fire_result('A1')).to eq('Hit!!')
      @game.player_fires('A2')
      expect(@game.player_fire_result('A2')).to eq('Hit!!')
      expect(@game.player_fire_ship_hit_result('A2')).to eq('The ship was sunk!!')
      expect(@game.display_computer_board_hidden). to eq("  1 2 3 4\nA X X . .\nB . . . .\nC . . . .\nD . . . .\n")
      expect(@game.display_computer_board_visible). to eq("  1 2 3 4\nA X X . .\nB . . . .\nC . . . .\nD . . . .\n")
    end

    it 'displays a players board after a players ship is sunk' do
      @game.player_board.place(Ship.new('sub',2),['A1','A2'])
      @game.computer_fires('A1')
      expect(@game.computer_fire_ship_hit_result('A1')).to eq('Your ship still floats..')
      expect(@game.computer_fire_result('A1')).to eq('Computer hits you!!')
      @game.computer_fires('A2')
      expect(@game.computer_fire_result('A2')).to eq('Computer hits you!!')
      expect(@game.computer_fire_ship_hit_result('A2')).to eq('Computer sinks your ship!!')
      expect(@game.display_player_board_hidden). to eq("  1 2 3 4\nA X X . .\nB . . . .\nC . . . .\nD . . . .\n")
      expect(@game.display_player_board_visible). to eq("  1 2 3 4\nA X X . .\nB . . . .\nC . . . .\nD . . . .\n")
    end

  end

  describe '#health checks' do
    it 'continues the game if player health is not 0' do
      sub = Ship.new('sub', 2)
      @computer_sub = sub
      @game.player_board.place(@computer_sub,['A1','A2'])
      @game.computer_fires('A1')
      expect(@game.computer_fire_ship_hit_result('A1')).to eq('Your ship still floats..')
      expect(@game.computer_fire_result('A1')).to eq('Computer hits you!!')
      expect(sub.health).to eq(1)
      expect(@game.check_players_health).to eq('Your turn!')
    end

    xit 'ends the game if player health is 0' do
      sub = Ship.new('sub', 2)
      @game.player_board.place(sub,['A1','A2'])
      @game.computer_fires('A1')

      @game.computer_fires('A2')
      expect(@game.check_game_result).to eq("I have emerged victorious... as always.")
    end

    it 'displays a header for the player board' do
      expect(@game.messages.display_player_header).to eq("--------- Player Board ---------")
    end

  end

  describe '#display headers for computer and player' do
    it 'displays a header for the computer board' do
      expect(@game.messages.display_computer_header).to eq("-------- Computer Board --------")
    end

    it 'displays a header for the player board' do
      expect(@game.messages.display_player_header).to eq("--------- Player Board ---------")
    end

  end

end
