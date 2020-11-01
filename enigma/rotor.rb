class Rotor
  attr_reader :name

  def initialize(name, type, notches, mapping)
    @name = name
    @type = type
    @notches = notches
    @mapping = mapping
    @position = 0
  end
end