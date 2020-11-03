class Body
  attr_accessor :x_pos, :y_pos, :x_vel, :y_vel
  attr_reader :mass

  def initialize(x_pos, y_pos, x_vel, y_vel, mass)
    @x_pos = x_pos
    @y_pos = y_pos
    @x_vel = x_vel
    @y_vel = y_vel
    @mass = mass
  end

  def clone
    Body.new(x_pos, y_pos, x_vel, y_vel, mass)
  end
end