class BasicTranslator
  attr_reader :name
  attr_accessor :right_rotor

  def initialize(name, alphabet, mapping, notches = [])
    @name = name
    @alphabet = alphabet
    @mapping = mapping
    @settable = false
    @notches = notches
  end

  def transform_from_right(character)
    if @mapping.key?(character)
      @mapping[character]
    elsif @mapping.value?(character)
      @mapping.key(character)
    else
      character
    end
  end

  def transform_from_left(character)
    transform_from_right(character)
  end

  def settable?
    @settable
  end

  def aligned_notch?
    @notches.include?(@alphabet[@position])
  end

  def rotate?
    false
  end
end

class Rotor < BasicTranslator
  attr_reader :position

  def initialize(name, alphabet, mapping, notches = [])
    super(name, alphabet, mapping, notches)
    @settable = true
  end

  def position=(letter)
    @position = @alphabet.index(letter)
  end

  def transform_from_right(character)
    contact_num = input_contact_num(character)
    if @mapping.key?(@alphabet[contact_num])
      translation = @mapping[@alphabet[contact_num]]
      @alphabet[exit_contact_num(translation)]
    else
      @alphabet[contact_num]
    end
  end

  def transform_from_left(character)
    contact_num = input_contact_num(character)
    if @mapping.value?(character)
      translation = @mapping.key(@alphabet[contact_num])
      @alphabet[exit_contact_num(translation)]
    else
      @alphabet[contact_num]
    end
  end

  private

  def input_contact_num(character)
    (@alphabet.index(character) + @position) % @alphabet.size
  end

  def exit_contact_num(character)
    (@alphabet.index(character) - @position) % @alphabet.size
  end
end

class MovingRotor < Rotor
  def rotate
    @position = (@position + 1) % @alphabet.size if rotate?
  end

  def rotate?
    right_rotor.nil? || right_rotor.aligned_notch?
  end
end

class Plugboard < BasicTranslator
  def transform(character)
    transform_from_left(character)
  end
end
