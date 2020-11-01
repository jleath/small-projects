load 'machine_config_info.rb'
load 'rotor.rb'

class EnigmaMachine
  attr_reader :config, :rotors
  def initialize(config_filename)
    @config = MachineConfigInfo.new(config_filename)
  end

  def install_rotors(rotor_names)
    @rotors = []
    rotor_names.each do |name|
      @rotors << config.rotors[name]
    end
  end

  def set_rotors(config_str)
    rotor_index = 0
    position_index = 0
    while rotor_index < @rotors.size
      curr_rotor = @rotors[rotor_index]
      if curr_rotor.settable?
        @rotors[rotor_index].position = config_str[position_index]
        position_index += 1
      end
      rotor_index += 1
    end
  end

  def prep_for_translation(input_filename)
    input = File.new(input_filename).readlines
    config_line = input[0].split[1..-1]
    rotor_names = config_line[0...config.rotor_slots]
    rotor_settings = config_line[config.rotor_slots]
    plugboard_settings = config_line[config.rotor_slots+1..-1]
    install_rotors(rotor_names)
    set_rotors(rotor_settings) 
    @plugboard = config.build_plugboard(plugboard_settings)
    @input = input[1..-1].join(' ')
  end

  def translate(input_filename)
    prep_for_translation(input_filename)
    output = []
    input = @input.delete("^#{config.alphabet}")
    input.chars.each do |curr_char|
      curr_char = stecker(curr_char)
      rotate_rotors
      intermediate = send_left(curr_char)
      result = send_right(intermediate)
      result = stecker(result)
      output << result
    end
    output.join('')
  end

  def stecker(character)
    @plugboard.transform(character)
  end

  def send_left(character)
    curr_rotor = @rotors.size - 1
    while curr_rotor >= 0
      character = @rotors[curr_rotor].transform_from_right(character)
      curr_rotor -= 1
    end
    character
  end

  def send_right(character)
    curr_rotor = 1
    while curr_rotor < @rotors.size
      character = @rotors[curr_rotor].transform_from_left(character)
      curr_rotor += 1
    end
    character
  end

  def rotate_rotors
    non_pawl_slots = config.rotor_slots - config.pawl_slots
    (non_pawl_slots...config.rotor_slots - 1).each do |index|
      @rotors[index].rotate if @rotors[index + 1].aligned_notch?
    end
    @rotors[config.rotor_slots - 1].rotate
  end
end

def format_enigma_output(str)
  words_per_line = 5
  chars_per_word = 5
  words_printed = 0
  chars_printed = 0
  str.chars.each do |char|
    if chars_printed == chars_per_word
      print(' ')
      chars_printed = 0
      words_printed += 1
    end
    if words_printed == words_per_line
      puts ''
      words_printed = 0 
    end
    print char
    chars_printed += 1
  end
  puts ''
end

machine = EnigmaMachine.new("config/machine_config.txt")
format_enigma_output(machine.translate("config/inputfile1.txt"))
puts ''
format_enigma_output(machine.translate("config/inputfile2.txt"))
