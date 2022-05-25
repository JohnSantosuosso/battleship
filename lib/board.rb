require_relative 'cell'
require_relative 'ship'

class Board
  attr_accessor :cells, :coordinates, :column_check_2, :column_check_3, :row_check_2, :row_check_3, :random_sub_coordinates, :random_cruiser_coordinates

  def initialize
    @coordinates = []
    @cells = create_cells
    @column_check_2 = [['A1','B1'],['B1', 'C1'],['C1','D1'], ['A2','B2'],['B2', 'C2'],['C2','D2'],['A3','B3'],['B3', 'C3'],['C3','D3'],['A4','B4'],['B4', 'C4'],['C4','D4']]
    @column_check_3 = [['A1','B1', 'C1'],['A2','B2', 'C2'],['A3','B3', 'C3'],['A4','B4', 'C4'],['B1','C1','D1'],['B2','C2','D2'],['B3','C3','D3'], ['B4','C4','D4']]
    @row_check_2 = [['A1','A2'],['A2', 'A3'],['A3','A4'], ['B1','B2'],['B2', 'B3'],['B3','B4'],['C1','C2'],['C2', 'C3'],['C3','C4'],['D1','D2'],['D2', 'D3'],['D3','D4']]
    @row_check_3 = [['A1','A2', 'A3'],['A2','A3', 'A4'],['B1','B2', 'B3'],['B2','B3', 'B4'],['C1','C2','C3'],['C2','C3','C4'],['D1','D2','D3'], ['D2','D3','D4']]
    @random_sub_coordinates = random_sub_coordinates
    @random_cruiser_coordinates = random_cruiser_coordinates
  end

  def create_cells
    build_coordinates
    @cells = Hash[@coordinates.map {|cell| [cell, Cell.new(cell)]}]
  end

  def build_coordinates
    @coordinates << (1..4).map { |i| 'A'.concat(i.to_s)}
    @coordinates << (1..4).map { |i| 'B'.concat(i.to_s)}
    @coordinates << (1..4).map { |i| 'C'.concat(i.to_s)}
    @coordinates << (1..4).map { |i| 'D'.concat(i.to_s)}
    @coordinates = @coordinates.flatten
  end

  def valid_coordinate?(cell)
    @cells.has_key? cell
  end

  def valid_placement?(ship_object, coordinate_array)
    check_for_overlapping_ships(coordinate_array) && coordinate_length_check?(ship_object, coordinate_array) && consecutive_column_check(ship_object,coordinate_array) || check_for_overlapping_ships(coordinate_array) && coordinate_length_check?(ship_object, coordinate_array) && consecutive_row_check(ship_object,coordinate_array)
  end

  def coordinate_length_check?(ship_object,coordinate_array)
    ship_object.length == coordinate_array.length ? true : false
  end

  def consecutive_row_check(ship_object,coordinate_array)
    if coordinate_array.length == 2
      @row_check_2.any? {|rows| rows == coordinate_array}
    else
      @row_check_3.any? {|rows| rows == coordinate_array}
    end
  end

  def consecutive_column_check(ship_object,coordinate_array)
    if coordinate_array.length == 2
      @column_check_2.any? {|columns| columns == coordinate_array}
    else
      @column_check_3.any? {|columns| columns == coordinate_array}
    end
  end

  def check_for_overlapping_ships(coordinate_array)
    coordinate_array.all? {|coordinate| @cells[coordinate].ship == nil}
  end

  def place(ship_object,coordinate_array)
      coordinate_array.each do |coordinate|
        @cells[coordinate].place_ship(ship_object)
      end
  end

  #Hardcoded arrays to build random coordinates for ships
    def random_coordinates_sub_computer
      @random_sub_coordinates = [@column_check_2, @row_check_2].sample(1).flatten!(1)
    end

    def random_coordinates_cruiser_computer
      @random_cruiser_coordinates = [@column_check_3, @row_check_3].sample(1).flatten!(1)
    end

  def render(show_ship_board = false)
    if show_ship_board == true
      header_row = '  '+["1", "2", "3", "4"].join(' ') + "\n"
      row_1 = ["A", @cells['A1'].render(true),@cells['A2'].render(true), @cells['A3'].render(true), @cells['A4'].render(true)].join(' ')  + "\n"
      row_2 = ["B", @cells['B1'].render(true),@cells['B2'].render(true), @cells['B3'].render(true), @cells['B4'].render(true)].join(' ')  + "\n"
      row_3 = ["C", @cells['C1'].render(true),@cells['C2'].render(true), @cells['C3'].render(true), @cells['C4'].render(true)].join(' ')  + "\n"
      row_4 = ["D", @cells['D1'].render(true),@cells['D2'].render(true), @cells['D3'].render(true), @cells['D4'].render(true)].join(' ')  + "\n"
      header_row + row_1 + row_2 + row_3 + row_4

    elsif show_ship_board == false
      header_row = '  '+["1", "2", "3", "4"].join(' ') + "\n"
      row_1 = ["A", @cells['A1'].render,@cells['A2'].render, @cells['A3'].render, @cells['A4'].render].join(' ')  + "\n"
      row_2 = ["B", @cells['B1'].render,@cells['B2'].render, @cells['B3'].render, @cells['B4'].render].join(' ')  + "\n"
      row_3 = ["C", @cells['C1'].render,@cells['C2'].render, @cells['C3'].render, @cells['C4'].render].join(' ')  + "\n"
      row_4 = ["D", @cells['D1'].render,@cells['D2'].render, @cells['D3'].render, @cells['D4'].render].join(' ')  + "\n"
      header_row + row_1 + row_2 + row_3 + row_4
      end
    end

end
