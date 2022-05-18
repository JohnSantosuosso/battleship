class Cell
attr_reader :coordinate,
            :ship
  def initialize(coordinate)
    @coordinate = coordinate
    @ship = nil
    @fired_upon = false
  end

  def empty?
    if ship == nil
      true
    else
      false
    end
  end


  def place_ship(boat)
    @ship = boat
  end

  def fired_upon?
    @fired_upon
  end

  def fire_upon
    if @ship != nil
      @ship.hit
      @fired_upon = true
    end
  end
end
