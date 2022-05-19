require './lib/board.rb'
require './lib/cell.rb'

RSpec.describe Board do
  before do
    @new_board = Board.new
  end

  describe '#initialize' do
    it 'is an instance of board' do
      expect(@new_board).to be_an_instance_of(Board)
    end

    it 'has no cells by default' do
      expect(@board_cells).to be(nil)
    end

    it 'has no values by default' do
      expect(@board).to be(nil)
    end
  end

    describe '#build_cells' do
      it 'builds an array from A1 to D4' do
        expect(@new_board.board_cells).to eql(["A1", "A2", "A3", "A4","B1", "B2", "B3", "B4","C1", "C2", "C3", "C4","D1", "D2", "D3", "D4",])
      end
    end

    describe '#create_hash_board' do
      it 'creates hash of new cells mapped to A1 to D4' do
        @new_board.build_cells
        @new_board.create_hash_board
        expect(@new_board.board.length).to eql(16)
      end
    end

    describe '#valid_coordinate' do
      it 'recognizes a valid coordinate' do
        expect(@new_board.valid_coordinate?('A1')).to eql(true)
      end

      it 'recognizes an invalid coordinate' do
        expect(@new_board.valid_coordinate?('A5')).to eql(false)
      end
    end

    describe '#valid_placement?' do
      it 'recognizes a valid placement by ship size' do
        cruiser = Ship.new("Cruiser", 3)
        submarine = Ship.new("Submarine", 2)
        expect(@new_board.valid_placement?(cruiser, ["A1", "A2"])).to eql(false)
        expect(@new_board.valid_placement?(submarine, ["A1", "A2"])).to eql(true)
      end

      it 'recognizes a valid placement by consecutive coordinates' do
        cruiser = Ship.new("Cruiser", 3)
        submarine = Ship.new("Submarine", 2)
        expect(@new_board.valid_placement?(cruiser, ["A1", "A2", "A4"])).to eql(false)
        expect(@new_board.valid_placement?(cruiser, ["A1", "A2", "A3"])).to eql(true)
        expect(@new_board.valid_placement?(submarine, ["B1", "B2"])).to eql(true)
      end

      it 'does not allow diagonal placements' do
        cruiser = Ship.new("Cruiser", 3)
        submarine = Ship.new("Submarine", 2)
        expect(@new_board.valid_placement?(cruiser, ["A1", "B2", "C3"])).to eql(false)
        expect(@new_board.valid_placement?(submarine, ["C2", "D3"])).to eql(false)
      end
    end

    describe '#valid_placement?' do
      it 'recognizes a valid placement by ship size' do
        cruiser = Ship.new("Cruiser", 3)
        submarine = Ship.new("Submarine", 2)
        expect(@new_board.valid_placement?(cruiser, ["A1", "A2"])).to eql(false)
        expect(@new_board.valid_placement?(submarine, ["A1", "A2"])).to eql(true)
      end

      it 'recognizes a valid placement by consecutive coordinates' do
        cruiser = Ship.new("Cruiser", 3)
        submarine = Ship.new("Submarine", 2)
        expect(@new_board.valid_placement?(cruiser, ["A1", "A2", "A4"])).to eql(false)
        expect(@new_board.valid_placement?(cruiser, ["B1", "C1", "D1"])).to eql(true)
        expect(@new_board.valid_placement?(submarine, ["B1", "B2"])).to eql(true)
      end
    end

    describe '#place ships' do
      it 'recognizes a valid placement by cells' do
        cruiser = Ship.new("Cruiser", 3)
        @new_board.place(cruiser, ["A1", "A2", "A3"])
        cell_1 = @new_board.cells["A1"]
        cell_2 = @new_board.cells["A2"]
        cell_3 = @new_board.cells["A3"]
        expect(cell_3.ship == cell_2.ship).to eql(true)
      end

      it 'does not recognize a valid placement' do
        cruiser = Ship.new("Cruiser", 3)
        @new_board.place(cruiser, ["A2", "A3", "A4"])
        cell_1 = @new_board.cells["A1"]
        cell_2 = @new_board.cells["A2"]
        cell_3 = @new_board.cells["A3"]
        expect(cell_1.ship == cell_2.ship).to eql(false)
      end

      it 'does not recognize a valid placement when ships overlap' do
        cruiser = Ship.new("Cruiser", 3)
        submarine = Ship.new("Submarine", 2)
        @new_board.place(cruiser, ["A1", "A2", "A3"])
        expect(@new_board.valid_placement?(submarine, ["A1", "A2"])).to eql(false)
      end
    end

    describe '#render' do
      it 'renders a board that does not show hidden ships' do
        cruiser = Ship.new("Cruiser", 3)
        @new_board.place(cruiser, ["A1", "A2", "A3"])
        expect(@new_board.render).to eql("1 2 3 4\nA . . . .\nB . . . .\nC . . . .\nD . . . .\n")
      end

      xit 'renders a board that shows hidden ships' do
        cruiser = Ship.new("Cruiser", 3)
        @new_board.place(cruiser, ["A2", "A3", "A4"])
        expect(@new_board.render(true)).to eql("  1 2 3 4 \nA S S S . \nB . . . . \nC . . . . \nD . . . . \n")
      end
    end
end
