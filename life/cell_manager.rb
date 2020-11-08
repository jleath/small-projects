require 'set'

class CellManager
  def initialize
    @live_cells = Hash.new { |hash, key| hash[key] = Set.new }
  end

  def update
    @checked = []
    @to_activate = []
    @to_deactivate = []

    active_cells.each do |cell|
      check_cell(cell)
      neighbors(*cell).each { |neighbor| check_cell(neighbor) }
    end

    @to_activate.each { |cell| activate_cell(*cell) }
    @to_deactivate.each { |cell| deactivate_cell(*cell) }
  end

  def activate_cell(x, y)
    @live_cells[x].add(y)
  end
  
  def shift_cells(shift)
    cells = active_cells.map { |cell| [cell.first + shift, cell.last + shift] }
    @live_cells = Hash.new { |hash, key| hash[key] = Set.new }
    cells.each { |cell| activate_cell(*cell) }
  end

  def deactivate_cell(x, y)
    @live_cells[x].delete(y) if @live_cells.key?(x)
  end

  def active_cell?(x, y)
    y_values = @live_cells[x]
    y_values.nil? ? false : y_values.include?(y)
  end

  def active_cells
    cells = []
    @live_cells.keys.each do |x_value|
      @live_cells[x_value].each do |y_value|
        cells << [x_value, y_value]
      end
    end
    cells
  end

  def check_cell(cell)
    return if @checked.include?(cell)
    @checked << cell
    state = determine_state(cell)
    case state
    when :active then @to_activate << cell
    when :inactive then @to_deactivate << cell
    end 
  end

  def determine_state(cell)
    active_neighbors = active_neighbors(*cell)
    if active_cell?(*cell)
      active_neighbors.between?(2, 3) ? :active : :inactive
    else
      # puts "(#{cell.first}, #{cell.last}) #{active_neighbors}"
      active_neighbors == 3 ? :active : :inactive
    end
  end

  def neighbors(x, y)
    [
      [x-1, y-1], [x, y-1], [x+1, y-1],
      [x-1, y], [x+1, y],
      [x-1, y+1], [x, y+1], [x+1, y+1]
    ]
  end

  def active_neighbors(x, y)
    neighbors(x, y).count { |cell| active_cell?(*cell)}
  end
end