# frozen_string_literal: true

require 'ruby2d'
load 'n_body.rb'

TIME_ARG_INDEX = 0
FILENAME_ARG_INDEX = 1
ARG_ERROR_MSG = "Invalid Arguments:\n\t-- USAGE [time] [filename]"
TIME_DELTA = 25_000.0
WINDOW_TITLE = 'NBody Simulation'
WINDOW_WIDTH = 1600
WINDOW_HEIGHT = 900
MIN_RADIUS = 2.0
RADIUS_SCALE_FACTOR = 20.0
DESIRED_REFRESH = 1.0 / 60.0

def window_position(body, radius)
  diameter = radius * 2.0
  half_width = WINDOW_WIDTH / 2.0
  half_height = WINDOW_HEIGHT / 2.0
  x_pos = (WINDOW_WIDTH * (body.x_pos / diameter))  + half_width
  y_pos = (WINDOW_HEIGHT * (body.y_pos / diameter)) + half_height
  [x_pos, y_pos]
end

def body_radius(mass, max_mass)
  MIN_RADIUS + ((mass / max_mass) * RADIUS_SCALE_FACTOR)
end

def draw_body_sprite(x_pos, y_pos, radius)
  Circle.new(x: x_pos, y: y_pos, radius: radius, color: 'random')
end

# Check and retrieve arguments
raise StandardError, ARG_ERROR_MSG if ARGV.size != 2

runtime = ARGV[TIME_ARG_INDEX].to_f
filename = ARGV[FILENAME_ARG_INDEX]
nbody = NBody.new(filename)

# Prep viewport
set title: WINDOW_TITLE + " - #{filename}"
set width: WINDOW_WIDTH, height: WINDOW_HEIGHT

# create body sprites
max_mass = nbody.bodies.max_by(&:mass).mass
body_sprites = nbody.bodies.map do |body|
  x, y = window_position(body, nbody.radius)
  radius = body_radius(body.mass, max_mass)
  draw_body_sprite(x, y, radius)
end

# game loop
elapsed = 0.0
update do
  close if elapsed > runtime
  t = Time.now
  # update bodies and their sprites
  nbody.update_bodies(TIME_DELTA)
  nbody.bodies.each_with_index do |body, index|
    x, y = window_position(body, nbody.radius)
    body_sprites[index].x = x
    body_sprites[index].y = y
  end
  # check frame time to maintain desired frame rate
  elapsed += TIME_DELTA
  frame_time = Time.now - t
  sleep(DESIRED_REFRESH - frame_time) if frame_time < DESIRED_REFRESH
  frame_time = Time.now - t
end

show
