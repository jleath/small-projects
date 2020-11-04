require 'ruby2d'
load 'n_body.rb'

def calc_window_position(body, radius, window_width, window_height)
  diameter = radius * 2.0
  half_width = window_width / 2.0
  half_height = window_height / 2.0

  x_pos = (window_width * (body.x_pos / diameter))  + half_width
  y_pos = (window_height * (body.y_pos / diameter)) + half_height
  [x_pos, y_pos]
end

TIME_ARG_INDEX = 0
FILENAME_ARG_INDEX = 1
ARG_ERROR_MSG = "Invalid Arguments:\n\t-- USAGE [time] [filename]"
TIME_DELTA = 25000
WINDOW_TITLE = "NBody Simulation"

raise StandardError, ARG_ERROR_MSG if ARGV.size != 2

time = ARGV[TIME_ARG_INDEX].to_f
puts time
update_rate = (time / 1000.0) * 60.0
filename = ARGV[FILENAME_ARG_INDEX]

nbody = NBody.new(time, update_rate, filename)

set title: WINDOW_TITLE + " - #{filename}"

window_width = get :width
window_height = get :height
elapsed = 0.0

# create body sprites
body_sprites = nbody.bodies.map do |body|
  x, y = calc_window_position(body, nbody.radius.to_f, window_width, window_height)
  Circle.new(x: x, y: y, radius: 10, color: 'random')
end

update do
  t = Time.now
  if elapsed > time then close end

  x_forces = []
  y_forces = []
  nbody.bodies.each_with_index do |body, index|
    x_forces[index] = body.net_force_exerted_by_x(nbody.bodies)
    y_forces[index] = body.net_force_exerted_by_y(nbody.bodies)
  end

  nbody.bodies.each_with_index do |body, index|
    body.update(TIME_DELTA, x_forces[index], y_forces[index])
    x, y = calc_window_position(body, nbody.radius.to_f, window_width, window_height)
    puts "#{index}: x->#{x} y->#{y}"
    body_sprites[index].x = x
    body_sprites[index].y = y
  end
  frame_time = Time.now - t
  if frame_time < (1.0 / 60.0)
    #sleep((1.0 / 60.0) - frame_time)
  end
  elapsed += TIME_DELTA
end

show