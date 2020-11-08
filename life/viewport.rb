class Viewport
  MAX_ZOOM = 3.0
  MIN_ZOOM = 0.25
  DEFAULT_ZOOM = 1.0
  DEFAULT_ORIGIN_X = 0
  DEFAULT_ORIGIN_Y = 0

  attr_reader :origin_x, :origin_y
  attr_accessor :zoom_factor, :width, :height

  def initialize(width, height)
    @origin_x, @origin_y = DEFAULT_ORIGIN_X, DEFAULT_ORIGIN_Y
    @width = width
    @height = height
    @zoom_factor = DEFAULT_ZOOM
  end

  def visible?(x1, y1, x2, y2)
    # puts "origin_x->#{@origin_x}, x->#{x}, x_max->#{x_max}, origin_y->#{@origin_y}, y->#{y}, y_max->#{y_max}"
    ((0...@width).cover?(x1) && (0...@height).cover?(y1)) ||
    ((0..@width).cover?(x2) && (0..@height).cover?(y2))
  end

  def set_origin(x, y)
    @origin_x = x
    @origin_y = y
  end

  def zoom_factor=(new_zoom)
    @zoom_factor = new_zoom if (MIN_ZOOM..MAX_ZOOM).cover?(new_zoom)
  end

  def translate(x_change, y_change)
    @origin_x += x_change
    @origin_y += y_change
  end
end
