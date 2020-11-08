require 'ruby2d'
load 'cell_manager.rb'
load 'viewport.rb'

SQUARE_SIZE = 10
ZOOM_AMOUNT = 0.1

INFO_BOX_SIZE = 100
@window_width = (get :width)
@window_height = (get :height) - INFO_BOX_SIZE
@input_delay = 0.03
@frame_delay = 0.16
FRAME_DELAY_CHANGE = 0.04
MAX_FRAME_DELAY = 1.0
MIN_FRAME_DELAY = 0.04
@last_input_time = Time.now
@draw_grid = true

@viewport = Viewport.new(@window_width, @window_height)

def increase_speed
  new_delay = @frame_delay - FRAME_DELAY_CHANGE
  @frame_delay = new_delay < MIN_FRAME_DELAY ? MIN_FRAME_DELAY : new_delay
end

def decrease_speed
  new_delay = @frame_delay + FRAME_DELAY_CHANGE
  @frame_delay = new_delay > MAX_FRAME_DELAY ? MAX_FRAME_DELAY : new_delay
end

def draw_grid
  num_vertical_lines = @viewport.width / scaled_square_size
  num_horizontal_lines = @viewport.height / scaled_square_size
  x_position = @viewport.origin_x % scaled_square_size
  y_position = @viewport.origin_y % scaled_square_size

  (0..num_vertical_lines).each do |line_no|
    draw_vertical_gridline(x_position, @viewport.height)
    x_position += scaled_square_size
  end
  (0..num_horizontal_lines).each do |line_no|
    draw_horizontal_gridline(y_position, @viewport.width)
    y_position += scaled_square_size
  end
end

def draw_vertical_gridline(x, length, width = 1, color = 'gray')
  Line.new(x1: x, y1: 0, x2: x, y2: length, width: width, color: color)
end

def draw_horizontal_gridline(y, length, width = 1, color = 'gray')
  Line.new(x1: 0, y1: y, x2: length, y2: y, width: width, color: color)
end

def draw_square(x, y)
  size = scaled_square_size
  x1 = size * x + @viewport.origin_x
  y1 = size * y + @viewport.origin_y
  x2 = x1 + size
  y2 = y1 + size
  if @viewport.visible?(x1, y1, x2, y2)
    Square.new(x: x1, y: y1, size: size, color: 'gray')
  end
end

def draw_cells(cells)
  cells.each do |cell|
    draw_square(cell.first, cell.last)
  end
end

def scaled_square_size
  SQUARE_SIZE * @viewport.zoom_factor
end

def check_for_input?
  Time.now - @last_input_time > @input_delay
end

def redraw
  clear
  draw_grid if @draw_grid
  draw_cells(@cells.active_cells)
  sleep(@frame_delay) if @run_simulation
end

def get_square_position(x, y)
  x = (x - @viewport.origin_x) / scaled_square_size
  y = (y - @viewport.origin_y) / scaled_square_size
  [x.to_i, y.to_i]
end

def handle_mouse_click(event)
  event_handled = true
  if check_for_input?
    case event.button
    when :left
      @cells.activate_cell(*get_square_position(event.x, event.y))
    when :right
      @cells.deactivate_cell(*get_square_position(event.x, event.y))
    else
      event_handled = false
    end
  end
  @last_input_time = event_handled ? Time.now : @last_input_time
end

def handle_mouse_scroll(event)
  event_handled = false
  if check_for_input?
    zoom_by = ZOOM_AMOUNT * event.delta_y
    @viewport.zoom_factor += zoom_by
    event_handled = true
  end
  @last_input_time = event_handled ? Time.now : @last_input_time
end

def handle_key(event)
  event_handled = true
  if check_for_input?
    case event.type
    when :held
      x_translate = 0
      y_translate = 0
      case event.key
      when 'a' then x_translate += scaled_square_size
      when 'w' then y_translate += scaled_square_size
      when 'd' then x_translate -= scaled_square_size
      when 's' then y_translate -= scaled_square_size
      when 'keypad +' then increase_speed
      when 'keypad -' then decrease_speed
      else event_handled = false
      end
      @viewport.translate(x_translate, y_translate)
    when :up
      case event.key
      when 'space' then @run_simulation = !@run_simulation
      when '/' then @draw_grid = !@draw_grid
      else event_handled = false
      end
    end
  else
    event_handled = false
  end
  @last_input_time = event_handled ? Time.now : @last_input_time
end

set background: 'black'

draw_grid

@cells = CellManager.new
@run_simulation = false

update do
  # Handle Input
  on :mouse_scroll do |event|
    handle_mouse_scroll(event)
  end

  on :key do |event|
    handle_key(event)
  end

  #on :key_down do |event|
  #  handle_key_press(event)
  #end

  on :mouse_up do |event|
    handle_mouse_click(event)
  end

  @cells.update if @run_simulation

  redraw

end

show