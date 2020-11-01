load 'rotor.rb'

class EnigmaError < StandardError ; end

class MachineConfig
  FIRST_ROTOR_LINE = 2
  ALPHABET_LINE = 0
  ROTOR_COUNT_LINE = 1
  CYCLE_DELIMITERS = '()'
  ROTOR_TYPE_CODES =
    { 'M' => :moving, 'N' => :non_moving, 'R' => :reflector }.freeze
  attr_reader :alphabet, :rotor_slots, :pawl_slots, :rotors, :plugboard

  def initialize(config_filename)
    config = File.new(config_filename).readlines
    @alphabet = read_alphabet(config)
    @rotor_slots = read_rotor_slots(config)
    @pawl_slots = read_pawl_slots(config)
    @rotors = read_rotors(config)
    @plugboard = Plugboard.new('plugboard', @alphabet, {})
  end

  def build_plugboard(config)
    @plugboard = Plugboard.new('plugboard', @alphabet, build_mapping(config))
  end

  def first_moving_rotor
    rotor_slots - pawl_slots
  end

  private

  def read_alphabet(config)
    alphabet = config[ALPHABET_LINE].strip
    if alphabet.chars.uniq != alphabet.chars
      raise EnigmaError, 'Invalid alphabet in config file: Duplicate Character'
    end
    alphabet
  end

  def valid_int?(val)
    !!/^\d+$/.match(val)
  end

  def read_rotor_slots(config)
    num_slots = config[ROTOR_COUNT_LINE].split[0]
    unless valid_int?(num_slots)
      raise EnigmaError, 'Invalid roster slot count in config file'
    end
    num_slots.to_i
  end

  def read_pawl_slots(config)
    num_pawls = config[ROTOR_COUNT_LINE].split[1]
    unless valid_int?(num_pawls)
      raise EnigmaError, 'Invalid pawl slot count in config file'
    end
    if num_pawls.to_i > rotor_slots
      raise EnigmaError, 'Pawl slot count is greater than total slot count'
    end
    num_pawls.to_i
  end

  def read_rotors(config)
    rotor_info = {}
    config[FIRST_ROTOR_LINE..-1].each do |rotor_config|
      new_rotor = build_rotor(rotor_config)
      rotor_info[new_rotor.name] = new_rotor
    end
    rotor_info
  end

  def build_rotor(config)
    config = config.split
    name = read_rotor_name(config)
    type = read_rotor_type(config)
    notches = read_rotor_notches(config)
    mapping = build_mapping(config[2..-1])
    case type
    when :moving then MovingRotor.new(name, @alphabet, mapping, notches)
    when :non_moving then Rotor.new(name, @alphabet, mapping)
    when :reflector then BasicTranslator.new(name, @alphabet, mapping)
    end
  end

  def build_mapping(cycles)
    mapping = {}
    cycles.each do |cycle|
      cycle = cycle.delete(CYCLE_DELIMITERS).chars
      cycle.each_index do |index|
        if mapping.key?(cycle[index])
          raise EnigmaError, 'Duplicate character in cycle notation'
        end
        mapping[cycle[index]] = cycle[(index + 1) % cycle.size]
      end
    end
    mapping
  end

  def read_rotor_name(config)
    if config[0].nil?
      raise EnigmaError, 'Missing rotor name'
    end
    config[0]
  end

  def read_rotor_type(config)
    type = ROTOR_TYPE_CODES[config[1].split('').first]
    if type.nil?
      raise EnigmaError, 'Invalid rotor type code'
    end
    type
  end

  def read_rotor_notches(config)
    notches = config[1].split('')[1..-1]
    notches.each do |character|
      unless alphabet.include?(character)
        raise EnigmaError, 'Notch value not found in alphabet' 
      end
    end
    notches
  end
end

class SessionConfig
  attr_reader :rotor_names, :rotor_settings, :plugboard_settings, :input
  def initialize(input_filename, machine_config)
    input = File.new(input_filename).readlines
    config_line = input[0].split[1..-1]
    @rotor_names = read_rotor_names(config_line, machine_config)
    @rotor_settings = read_rotor_settings(config_line, machine_config)
    @plugboard_settings = read_plugboard_settings(config_line, machine_config)
    @input = read_input(input, machine_config)
  end

  private

  def read_rotor_names(config_str, machine_config)
    config_str[0...machine_config.rotor_slots]
  end

  def read_rotor_settings(config_str, machine_config)
    config_str[machine_config.rotor_slots]
  end

  def read_plugboard_settings(config_str, machine_config)
    config_str[machine_config.rotor_slots + 1..-1]
  end

  def read_input(input_lines, machine_config)
    input_lines[1..-1].join(' ').delete("^#{machine_config.alphabet}")
  end
end
