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

  end
end
