require './lib/ship'

RSpec.describe Ship do
  before do
    @cruiser = Ship.new("Cruiser",3)
  end

    it 'creates an instance of ship' do
      expect(@cruiser).to be_instance_of(Ship)
    end

    it 'has a name' do
      expect(@cruiser.name).to eq("Cruiser")
    end

    it 'has a length' do
      expect(@cruiser.length).to eq(3)
    end

    it 'has health' do
      expect(@cruiser.health).to eq(3)
    end

    it 'isnt sunk?' do
      expect(@cruiser.sunk?).to eq(false)
    end

    it 'takes a hit' do
      @cruiser.hit

      expect(@cruiser.health).to eq(2)
    end

    it 'it is sunk?' do
      @cruiser.hit
      @cruiser.hit
      @cruiser.hit

      expect(@cruiser.sunk?).to eq(true)
    end
end
