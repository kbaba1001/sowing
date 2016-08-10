class Sowing::Runner
  attr_reader :data_directory

  def initialize(data_directory: nil)
    @data_directory = data_directory || Sowing::Configuration.config.default_data_directory
  end

  def create(klass)
    data_directory
  end
end
