require './lib/ship'
require './lib/cell'

RSpec.describe Cell do
  before do
    @cell = Cell.new("B4")
  end

  it 'creates an instance of cell' do
    expect(@cell).to be_instance_of(Cell)
  end

  it 'has coordinates' do
    expect(@cell.coordinate).to eq("B4")
  end

  it 'has a ship' do
    expect(@cell.ship).to eq(nil)
  end

  it 'is empty?' do
    expect(@cell.empty?).to eq(true)
  end

  it 'place ship' do
    cruiser = Ship.new("Cruiser", 3)
    @cell.place_ship(cruiser)

    expect(@cell.ship).to eq(cruiser)
    expect(@cell.empty?).to eq(false)
  end
end
