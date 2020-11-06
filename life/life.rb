require 'ruby2d'
load 'cell_manager.rb'

class SquarePosition
  def initialize(x, y)
    @x_pos = x
    @y_pos = y
  end
end

cells = CellManager.new

def draw_grid
  num_lines = WINDOW_WIDTH / @square_size
  Line.new(x1: 1, y1: 1, x2: WINDOW_WIDTH, y2: 1, width: 1, color: 'gray')
  Line.new(x1: 1, y1: 1, x2: 1, y2: WINDOW_HEIGHT, width: 1, color: 'gray')
  (0..num_lines).each do |line_no|
    Line.new(x1: 0, y1: line_no * @square_size, x2: WINDOW_WIDTH, y2: line_no * @square_size, width: 1, color: 'gray')
    Line.new(x1: line_no * @square_size, y1: 0, x2: line_no * @square_size, y2: WINDOW_HEIGHT, width: 1, color: 'gray')
  end
end

@times_called = 0
@last_square_created = Time.now
@rows_added = 0

def get_square_position(x_click, y_click)
  @times_called += 1
  puts @times_called
  x = (x_click / @square_size)
  y = (y_click / @square_size)
  [x, y]
end

def draw_square(x, y)
  Square.new(x: x * @square_size, y: y * @square_size, size: @square_size, color: 'gray')
end

def draw_cells(cells)
  cells.each do |cell|
    draw_square(cell.first, cell.last)
  end
end

WINDOW_WIDTH = 640
WINDOW_HEIGHT = 640
@num_squares = 60
@square_size = WINDOW_WIDTH / @num_squares 
INPUT_DELAY = 0.1

set background: 'black', width: WINDOW_WIDTH, height: WINDOW_HEIGHT

draw_grid
@last_input = Time.now
@need_refresh = false
@run_simulation = false
@frame_delay = 0.4
@draw_grid = true

update do
  on :mouse_scroll do |event|
    if Time.now - @last_input > INPUT_DELAY
      puts "Scroll -> #{event.delta_y}"
      puts "#{@square_size}"
      @last_input = Time.now
      @need_refresh = true
      @num_squares += (2 * event.delta_y) if @square_size > 4
      @square_size = WINDOW_WIDTH / @num_squares
      cells.shift_cells(event.delta_y)
    end
  end
  on :mouse_up do |event|
    if Time.now - @last_input > INPUT_DELAY
      if event.button == :left && Time.now - @last_input > INPUT_DELAY
        @last_input = Time.now
        @need_refresh = true
        x, y = get_square_position(event.x, event.y)
        cells.activate_cell(x, y)
      elsif event.button == :right
        @need_refresh = true
        x, y = get_square_position(event.x, event.y)
        cells.deactivate_cell(x, y)
      end
    end
  end
  on :key_up do |event|
    if Time.now - @last_input > INPUT_DELAY
      @last_input = Time.now
      if event.key == 'space'
        @run_simulation = !@run_simulation
      elsif event.key == 'keypad +'
        @frame_delay -= 0.05 if @frame_delay > 0.15
      elsif event.key == 'keypad -'
        @frame_delay += 0.05 if @frame_delay < 0.75
      elsif event.key == '/'
        @draw_grid = !@draw_grid
      end
    end
  end
  if @run_simulation
    cells.update
    sleep(@frame_delay)
  end
  if @need_refresh || @run_simulation
    @need_refresh = false
    clear
    draw_grid if @draw_grid
    draw_cells(cells.active_cells)
  end
end

show