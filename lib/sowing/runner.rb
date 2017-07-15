class Sowing::Runner
  EXTENSIONS = %w(csv yaml yml)
  attr_reader :data_directory

  def initialize(data_directory: nil)
    @data_directory = Pathname(data_directory || Sowing::Configuration.config.default_data_directory)
    @csv_strategy = Sowing::Configuration.config.csv_strategy.new
  end

  def create(klass, filename: nil)
    find_file(klass, filename: filename) do |file|
      @csv_strategy.create(klass, file)
    end
  end

  def create_or_do_nothing(klass, finding_key, filename: nil)
    find_file(klass, filename: filename) do |file|
      @csv_strategy.create_or_do_nothing(klass, file, finding_key)
    end
  end

  def create_or_update(klass, finding_key, filename: nil)
    find_file(klass, filename: filename) do |file|
      @csv_strategy.create_or_update(klass, file, finding_key)
    end
  end

  private

  def find_file(klass, filename: nil)
    if filename
      file = data_directory.join(filename)
      if file.exist?
        yield(file)
      else
        raise "not found: #{file}"
      end

      return
    end

    pathname = data_directory.join(klass.to_s.underscore.pluralize)
    ext = EXTENSIONS.find {|ext| Pathname("#{pathname}.#{ext}").exist? }

    if ext
      yield(Pathname("#{pathname}.#{ext}"))
    else
      raise "not found: #{pathanme}.(#{EXTENSIONS.join('|')})"
    end
  end
end
