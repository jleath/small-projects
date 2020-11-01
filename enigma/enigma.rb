load 'machine_config.rb'
load 'rotor.rb'

WORDS_PER_LINE = 5
CHARS_PER_WORD = 5

class EnigmaMachine
  FIRST_MOVING_ROTOR_INDEX = 1

  attr_reader :config, :rotors
  def initialize(config_filename)
    @config = MachineConfig.new(config_filename)
  rescue EnigmaError => e
    puts e.message
    exit
  end

  def install_rotors(rotor_names)
    @rotors = []
    rotor_names.each_with_index do |name, index|
      curr_rotor = config.rotors[name]
      if index < rotor_names.size - 1
        next_rotor_name = rotor_names[index + 1]
        next_rotor = config.rotors[next_rotor_name]
        curr_rotor.right_rotor = next_rotor
      end
      @rotors << curr_rotor
    end
  end

  def configure_rotors(config_str)
    rotor_index = FIRST_MOVING_ROTOR_INDEX
    config_str.chars.each do |position|
      curr_rotor = @rotors[rotor_index]
      curr_rotor.position = position
      rotor_index += 1
    end
  end

  def prep_for_translation(input_filename)
    @session = SessionConfig.new(input_filename, config)
    install_rotors(@session.rotor_names)
    configure_rotors(@session.rotor_settings)
    config.build_plugboard(@session.plugboard_settings)
  rescue => e
    puts e.message
    exit
  end

  def translate(input_filename)
    prep_for_translation(input_filename)
    output = []
    @session.input.chars.each do |curr_char|
      result = send_through_rotors(curr_char)
      output << result
    end
    output.join('')
  end

  def send_through_rotors(char)
    char = stecker(char)
    rotate_rotors
    intermediate = send_left(char)
    result = send_right(intermediate)
    stecker(result)
  end

  def stecker(character)
    config.plugboard.transform(character)
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
    @rotors.each { |rotor| rotor.rotate if rotor.rotate? }
  end
end

def format_enigma_output(str)
  curr_char = 0
  words_printed = 0
  while curr_char < str.size
    print str[curr_char...curr_char + CHARS_PER_WORD] + ' '
    curr_char += CHARS_PER_WORD
    words_printed += 1
    puts '' if (words_printed % WORDS_PER_LINE).zero?
  end
end

machine = EnigmaMachine.new('config/machine_config.txt')
format_enigma_output(machine.translate('config/inputfile1.txt'))
puts ''
format_enigma_output(machine.translate('config/inputfile2.txt'))
