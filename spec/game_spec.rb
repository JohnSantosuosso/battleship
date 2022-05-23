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

end
