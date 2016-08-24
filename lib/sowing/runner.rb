class Sowing::Runner
  attr_reader :data_directory

  def initialize(data_directory: nil)
    @data_directory = Pathname(data_directory || Sowing::Configuration.config.default_data_directory)
    @csv_strategy = Sowing::Configuration.config.csv_strategy.new
  end

  def create(klass, filename: nil)
    find_csv_file(klass, filename: filename) do |file|
      @csv_strategy.create(klass, file)
    end
  end

  def create_or_do_nothing(klass, finding_key, filename: nil)
    find_csv_file(klass, filename: filename) do |file|
      @csv_strategy.create_or_do_nothing(klass, file, finding_key)
    end
  end

  def create_or_update(klass, finding_key, filename: nil)
    find_csv_file(klass, filename: filename) do |file|
      @csv_strategy.create_or_update(klass, file, finding_key)
    end
  end

  private

  def find_csv_file(klass, filename: nil)
    csv_file = data_directory.join(filename || "#{klass.to_s.downcase.pluralize}.csv")

    if csv_file.exist?
      yield(csv_file)
    end
  end
end
