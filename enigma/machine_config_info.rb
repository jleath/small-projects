load 'rotor.rb'

class MachineConfigInfo
  ROTOR_TYPE_CODES = { 'M' => :moving, 'N' => :non_moving, 'R' => :reflector }
  attr_reader :alphabet, :rotor_slots, :pawl_slots, :rotors

  def initialize(config_filename)
    config = File.new(config_filename).readlines
    @alphabet = read_alphabet(config)
    @rotor_slots = read_rotor_slots(config)
    @pawl_slots = read_pawl_slots(config)
    @rotors = read_rotors(config)
  end

  private

  def read_alphabet(config)
    config[0].strip
  end

  def read_rotor_slots(config)
    config[1].split[0].to_i
  end

  def read_pawl_slots(config)
    config[1].split[1].to_i
  end

  def read_rotors(config)
    rotor_info = {}
    config[2..-1].each do |rotor_config|
      new_rotor = build_rotor(rotor_config)
      rotor_info[new_rotor.name] = new_rotor
    end
    rotor_info
  end

  def build_rotor(config)
    config = config.split
    name = config[0]
    type = ROTOR_TYPE_CODES[config[1].split('').first]
    notches = config[1].split('')[1..-1]
    mapping = build_mapping(config[2..-1])
    Rotor.new(name, type, notches, mapping)
  end

  def build_mapping(cycles)
    mapping = {}
    cycles.each do |cycle|
      cycle = cycle.delete('()').chars
      cycle.each_index do |index|
        mapping[cycle[index]] = cycle[(index + 1) % cycle.size]
      end
    end
    mapping
  end
end