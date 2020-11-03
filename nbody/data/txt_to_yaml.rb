class Body
  attr_accessor :x_pos, :y_pos, :x_vel, :y_vel, :mass
  def to_s
    "  -\n    x_pos: #{x_pos}\n    y_pos: #{y_pos}\n" \
    "    x_vel: #{x_vel}\n    y_vel: #{y_vel}\n    mass: #{mass}\n"
  end
end

class DataBlob
  attr_accessor :num_planets, :radius, :bodies

  def to_s
    output_str = "num_planets: #{num_planets}\nradius: #{radius}\nbodies:\n"
    bodies.each do |body|
      output_str += body.to_s
    end
    output_str
  end
end

NUM_BODIES_LINE_NO = 0
RADIUS_LINE_NO = 1
START_OF_BODIES_LINE_NO = 2
X_POSITION_INDEX = 0
Y_POSITION_INDEX = 1
X_VELOCITY_INDEX = 2
Y_VELOCITY_INDEX = 3
MASS_INDEX = 4

def convert(filename)
  lines = File.open(filename).readlines
  bodies = []
  data = DataBlob.new

  data.num_planets = read_num_planets(lines)
  data.radius = read_radius(lines)
  data.bodies = read_bodies(lines, data.num_planets.to_i)
  data
end

def read_bodies(text_lines, num_bodies)
  bodies = []
  num_bodies.times do |index|
    body_properties = text_lines[index + START_OF_BODIES_LINE_NO].split
    bodies << read_body(body_properties)
  end
  bodies
end

def read_body(line)
  body = Body.new
  body.x_pos = line[X_POSITION_INDEX]
  body.y_pos = line[Y_POSITION_INDEX]
  body.x_vel = line[X_VELOCITY_INDEX]
  body.y_vel = line[Y_VELOCITY_INDEX]
  body.mass = line[MASS_INDEX]
  body
end

def read_num_planets(text_lines)
  text_lines[NUM_BODIES_LINE_NO].strip
end

def read_radius(text_lines)
  text_lines[RADIUS_LINE_NO].strip
end

def output(data, filename)
  output_file = File.open(filename, "w")
  output_file.print(data)
  output_file.close
end

raise StandardError, "filename required" if ARGV.empty?
filename = ARGV[0]
data = convert(filename)
new_filename = filename.slice(0, filename.size - 4) + '.yml'
output(data, new_filename)
