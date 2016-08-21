class Sowing::Runner
  attr_reader :data_directory

  def initialize(data_directory: nil)
    @data_directory = Pathname(data_directory || Sowing::Configuration.config.default_data_directory)
    @csv_strategy = Sowing::Configuration.config.csv_strategy.new
  end

  def create(klass)
    csv_file = data_directory.join("#{klass.to_s.downcase.pluralize}.csv")

    if csv_file.exist?
      @csv_strategy.read(klass, csv_file)
    end
  end
end
