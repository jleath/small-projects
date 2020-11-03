# frozen_string_literal: true

require 'yaml'
load 'body.rb'

ARG_ERROR_MSG = "Invalid Arguments:\n\t-- USAGE [T] [dt] [filename]"

class NBody
  attr_reader :radius, :bodies, :time, :update_rate

  def initialize(sim_time, update_rate, init_file)
    @time = sim_time
    @update_rate = update_rate
    universe_info = YAML.load_file(init_file)
    num_bodies = universe_info['num_planets']
    @radius = universe_info['radius']
    body_data = universe_info['bodies']
    @bodies = (0...num_bodies).map { |index| read_body(body_data[index]) }
  end

  def num_bodies
    bodies.size
  end

  def to_s
    output_str = "time -> #{time}\nupdate_rate -> " \
                 "#{update_rate}\nradius -> #{radius}\nbodies:\n"
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

raise StandardError, ARG_ERROR_MSG if ARGV.size != 3

puts NBody.new(ARGV[0], ARGV[1], ARGV[2])
