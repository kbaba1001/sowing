class Sowing::Runner
  attr_reader :data_directory, :proxy

  def initialize(data_directory: nil)
    @data_directory = Pathname(data_directory || Sowing::Configuration.config.default_data_directory)
    @proxy = Sowing::DefinitionProxy.new
  end

  def create(klass, filename: nil, &block)
    # proxy.instance_eval(&block) if block_given?

    find_file(klass, filename: filename) do |file, strategy|
      strategy.read_data(file).each do |row|
        strategy.create(klass, row)
      end
    end
  end

  def create_or_do_nothing(klass, finding_key, filename: nil)
    find_file(klass, filename: filename) do |file, strategy|
      strategy.read_data(file).each do |row|
        strategy.create_or_do_nothing(klass, row, finding_key)
      end
    end
  end

  def create_or_update(klass, finding_key, filename: nil)
    find_file(klass, filename: filename) do |file, strategy|
      strategy.read_data(file).each do |row|
        strategy.create_or_update(klass, row, finding_key)
      end
    end
  end

  private

  def find_file(klass, filename: nil)
    if filename
      file = data_directory.join(filename)
      if file.exist?
        yield(file, select_strategy(file.extname[1..-1]))
      else
        raise DataFileNotFound.new("not found: #{file}")
      end

      return
    end

    pathname = data_directory.join(klass.to_s.underscore.pluralize)
    ext = Sowing::Configuration.config.extensions.find {|ext| Pathname("#{pathname}.#{ext}").exist? }

    if ext
      yield(Pathname("#{pathname}.#{ext}"), select_strategy(ext))
    else
      raise DataFileNotFound.new("not found: #{pathanme}.(#{Sowing::Configuration.config.extensions.join('|')})")
    end
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
