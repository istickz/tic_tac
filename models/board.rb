class Board
  attr_reader :cells

  def initialize(cells)
    @cells = cells
  end

  def place_symbol(index, value)
    cells[index] = value
  end

  def full?
    cells.select{|cell| cell == ' '}.size == 0
  end

  def new?
    cells.select{|cell| cell == ' '}.size == cells.size
  end
end