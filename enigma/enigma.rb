load 'machine_config_info.rb'
load 'rotor.rb'

class EnigmaMachine
  def initialize(config_filename)
    @machine_config = MachineConfigInfo.new(config_filename)
  end
end

machine = EnigmaMachine.new("config/machine_config.txt")
