# frozen_string_literal: true

require 'yaml'
load 'body.rb'

class NBody
  attr_reader :radius, :bodies, :time

  def initialize(init_file)
    universe_info = YAML.load_file(init_file)
    num_bodies = universe_info['num_planets'].to_i
    @radius = universe_info['radius'].to_f
    body_data = universe_info['bodies']
    @bodies = (0...num_bodies).map { |index| read_body(body_data[index]) }
  end

  def update_bodies(time_delta)
    x_forces = bodies.map { |body| body.net_force_exerted_by_x(bodies) }
    y_forces = bodies.map { |body| body.net_force_exerted_by_y(bodies) }

    bodies.each_with_index do |body, index|
      body.update(time_delta, x_forces[index], y_forces[index])
    end
  end

  def num_bodies
    bodies.size
  end

  def to_s
    output_str = "radius -> #{radius}\nbodies:\n" 
    bodies.each do |body|
      output_str += body.to_s + "\n"
    end
    output_str
  end

  private

  def read_body(body_info)
    Body.new(body_info['x_pos'], body_info['y_pos'], body_info['x_vel'],
             body_info['y_vel'], body_info['mass'])
  end
end
