# frozen_string_literal: true

require 'ruby2d'
load 'n_body.rb'

TIME_ARG_INDEX = 0
FILENAME_ARG_INDEX = 1
ARG_ERROR_MSG = "Invalid Arguments:\n\t-- USAGE [time] [filename]"
TIME_DELTA = 25_000
WINDOW_TITLE = 'NBody Simulation'
WINDOW_WIDTH = 1600
WINDOW_HEIGHT = 900

def window_position(body, radius, window_width, window_height)
  diameter = radius * 2.0
  half_width = window_width / 2.0
  half_height = window_height / 2.0

  x_pos = (window_width * (body.x_pos / diameter))  + half_width
  y_pos = (window_height * (body.y_pos / diameter)) + half_height
  [x_pos, y_pos]
end

# Check and retrieve arguments
raise StandardError, ARG_ERROR_MSG if ARGV.size != 2

time = ARGV[TIME_ARG_INDEX].to_f
update_rate = (time / 1000.0) * 60.0
filename = ARGV[FILENAME_ARG_INDEX]
nbody = NBody.new(time, update_rate, filename)

# Prep viewport
set title: WINDOW_TITLE + " - #{filename}"
set width: WINDOW_WIDTH, height: WINDOW_HEIGHT
window_width = get :width
window_height = get :height

# create body sprites
max_mass = nbody.bodies.max_by(&:mass).mass
body_sprites = nbody.bodies.map do |body|
  x, y = window_position(body, nbody.radius.to_f, window_width, window_height)
  body_radius = 2 + ((body.mass / max_mass) * 20.0)
  Circle.new(x: x, y: y, radius: body_radius, color: 'random')
end

# game loop
elapsed = 0.0
update do
  close if elapsed > time

  nbody.update_bodies(TIME_DELTA)

  nbody.bodies.each_with_index do |body, index|
    x, y = window_position(body, nbody.radius, window_width, window_height)
    body_sprites[index].x = x
    body_sprites[index].y = y
  end
  elapsed += TIME_DELTA
end

show
