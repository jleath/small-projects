# frozen_string_literal: true

# A body in an n-body simulation
class Body
  G = 6.67e-11
  attr_accessor :x_pos, :y_pos, :x_vel, :y_vel
  attr_reader :mass

  def initialize(x_pos, y_pos, x_vel, y_vel, mass)
    @x_pos = x_pos.to_f
    @y_pos = y_pos.to_f
    @x_vel = x_vel.to_f
    @y_vel = y_vel.to_f
    @mass = mass.to_f
  end

  def clone
    Body.new(x_pos, y_pos, x_vel, y_vel, mass)
  end

  def update(time_delta, x_force, y_force)
    puts "x_force->#{x_force}"
    puts "mass->#{mass}"
    x_acceleration = x_force / mass
    y_acceleration = y_force / mass
    puts "x_acceleration->#{x_acceleration}"
    puts "time_delta->#{time_delta}"
    puts "x_vel->#{@x_vel}"
    @x_vel += (time_delta * x_acceleration)
    @y_vel += (time_delta * y_acceleration)
    @x_pos += (time_delta * @x_vel)
    @y_pos += (time_delta * @y_vel)
  end

  def net_force_exerted_by_x(bodies)
    bodies.reduce(0.0) { |net_force, body| equal?(body) ? net_force : net_force + force_exerted_by_x(body) }
  end

  def net_force_exerted_by_y(bodies)
    bodies.reduce(0.0) { |net_force, body| equal?(body) ? net_force : net_force + force_exerted_by_y(body) }
  end

  def to_s
    [x_pos, y_pos, x_vel, y_vel, mass].to_s
  end

  private

  def x_distance(other)
    other.x_pos - x_pos
  end

  def y_distance(other)
    other.y_pos - y_pos
  end

  def distance(other)
    x_diff = x_distance(other)
    y_diff = y_distance(other)
    Math.sqrt((x_diff**2) + (y_diff**2))
  end

  def force_exerted_by(other)
    return 0.0 if equal?(other)

    distance = self.distance(other)
    ((mass * other.mass) / (distance**2)) * G
  end

  def force_exerted_by_x(other)
    (force_exerted_by(other) * x_distance(other)) / distance(other)
  end

  def force_exerted_by_y(other)
    (force_exerted_by(other) * y_distance(other) / distance(other))
  end
end
