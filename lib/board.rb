class Board
  attr_accessor :board_cells, :board

  def initialize
    @board_cells = []
    @board = { }
  end

  def build_cells
    @board_cells << (1..4).map { |i| 'A'.concat(i.to_s)}
    @board_cells << (1..4).map { |i| 'B'.concat(i.to_s)}
    @board_cells << (1..4).map { |i| 'C'.concat(i.to_s)}
    @board_cells << (1..4).map { |i| 'D'.concat(i.to_s)}
    @board_cells.flatten!
  end

  def create_hash_board
    @board = Hash[@board_cells.flatten.map {|cell| [cell, Cell.new(cell)]}]
  end

  def valid_coordinate?(cell)
    @board.include? cell
  end


end
