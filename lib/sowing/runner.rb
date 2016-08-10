class Sowing::Runner
  def initialize(data_directory: nil)
    @data_directory = data_directory || Sowing::Configuration.config.default_data_directory
  end

  def create(klass)
    p @data_directory
  end
end
