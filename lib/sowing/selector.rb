class Sowing::Selector
  attr_reader :data_directory

  def initialize(data_directory)
    @data_directory = data_directory
  end

  # @return [Array<Pathname, Sowing::Strategies>]
  def find(klass, filename = nil)
    if filename
      find_file_from_filename(filename)
    else
      file_file_from_convention(klass)
    end
  end

  private

  def find_file_from_filename(filename)
    file = data_directory.join(filename)

    raise DataFileNotFound.new("not found: #{file}") unless file.exist?

    [file, select_strategy(file.extname[1..-1])]
  end

  def file_file_from_convention(klass)
    pathname = data_directory.join(klass.to_s.underscore.pluralize)
    ext = Sowing::Configuration.config.extensions.find {|ext| Pathname("#{pathname}.#{ext}").exist? }

    raise DataFileNotFound.new("not found: #{pathanme}.(#{Sowing::Configuration.config.extensions.join('|')})") unless ext

    [Pathname("#{pathname}.#{ext}"), select_strategy(ext)]
  end

  def select_strategy(ext)
    strategy_klass = Sowing::Configuration.config.strategies[ext]

    if strategy_klass
      strategy_klass.new
    else
      raise StrategyNotFound.new("strategy not found: extension #{ext}")
    end
  end
end
