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

    describe '#build_cells' do
      it 'builds an array from A1 to D4' do
        expect(@new_board.build_cells).to eql(["A1", "A2", "A3", "A4","B1", "B2", "B3", "B4","C1", "C2", "C3", "C4","D1", "D2", "D3", "D4",])
      end
    end

    describe '#create_hash_board' do
      it 'creates hash of new cells mapped to A1 to D4' do
        @new_board.build_cells
        @new_board.create_hash_board
        expect(@board.count).to eql(16)
      end
    end

    describe '#valid_coordinate' do
      it 'recognizes a valid coordinate' do
        @new_board.build_cells
        @new_board.create_hash_board
        expect(@board.valid_coordinate?('A1')).to eql(true)
      end

      it 'recognizes an invalid coordinate' do
        @new_board.build_cells
        @new_board.create_hash_board
        expect(@board.valid_coordinate?('A5')).to eql(false)
      end
    end

    
end
