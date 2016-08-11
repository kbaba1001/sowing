require 'csv'

class Sowing::Runner
  attr_reader :data_directory

  def initialize(data_directory: nil)
    @data_directory = Pathname(data_directory || Sowing::Configuration.config.default_data_directory)
  end

  def create(klass)
    csv_file = data_directory.join("#{klass.to_s.downcase.pluralize}.csv")

    CSV.read(csv_file, headers: true).each do |row|
      print 'create: '
      p klass.create!(row.to_hash)
    end
  end
end
