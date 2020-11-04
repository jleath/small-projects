# frozen_string_literal: true

FLOAT_REGEX = /^\s*[+-]?((\d+_?)*\d+(\.(\d+_?)*\d+)?|\.(\d+_?)*\d+)(\s*|([eE][+-]?(\d+_?)*\d+)\s*)$/.freeze
NUM_BODIES_LINE_NO = 0
RADIUS_LINE_NO = 1
X_POSITION_INDEX = 0
Y_POSITION_INDEX = 1
X_VELOCITY_INDEX = 2
Y_VELOCITY_INDEX = 3
MASS_INDEX = 4
OUTPUT_PATH = './yaml_files/'
BODY_READ_ERR_MSG = 'Number of bodies read does not match file header'

class Body
  attr_accessor :x_pos, :y_pos, :x_vel, :y_vel, :mass
  def to_s
    "  -\n    x_pos: #{x_pos}\n    y_pos: #{y_pos}\n" \
    "    x_vel: #{x_vel}\n    y_vel: #{y_vel}\n    mass: #{mass}\n"
  end

  def valid?
    [x_pos, y_pos, x_vel, y_vel, mass].reject { |val| valid_float?(val) }.empty?
  end

  private

  def valid_float?(value)
    !!(value =~ FLOAT_REGEX)
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

  def valid?
    num_planets == bodies.size.to_s
  end
end

def convert(filename)
  lines = File.open(filename).readlines
  data = DataBlob.new

  data.num_planets = read_num_planets(lines)
  data.radius = read_radius(lines)
  data.bodies = read_bodies(lines)
  data
end

def read_bodies(data)
  data.map(&:split).map { |line| read_body(line) }.select(&:valid?)
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

def write_to_file(data, filename)
  output_file = File.open(filename, 'w')
  output_file.print(data)
  output_file.close
end

def extract_filename(filename)
  %r{[^\/]+\.}.match(filename).to_s[0..-2]
end

def report_error(data, filename)
  expected = data.num_planets
  actual = data.bodies.size
  output = "Error in file #{filename}: "
  output += BODY_READ_ERR_MSG + " - expected #{expected}, actual #{actual}"
  puts "Warning: #{output}"
end

filename = ARGV[0]
data = convert(filename)
report_error(data, filename) unless data.valid?
new_filename = OUTPUT_PATH + extract_filename(filename) + '.yml'
write_to_file(data, new_filename)
