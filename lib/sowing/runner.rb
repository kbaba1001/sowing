class Sowing::Runner
  attr_reader :data_directory

  def initialize(data_directory: nil)
    @data_directory = Pathname(data_directory || Sowing::Configuration.config.default_data_directory)
  end

  def create(klass, filename: nil)
    find_file(klass, filename: filename) do |file, strategy|
      strategy.create(klass, file)
    end
  end

  def create_or_do_nothing(klass, finding_key, filename: nil)
    find_file(klass, filename: filename) do |file, strategy|
      strategy.create_or_do_nothing(klass, file, finding_key)
    end
  end

  def create_or_update(klass, finding_key, filename: nil)
    find_file(klass, filename: filename) do |file, strategy|
      strategy.create_or_update(klass, file, finding_key)
    end
  end

  private

  def find_file(klass, filename: nil)
    if filename
      file = data_directory.join(filename)
      if file.exist?
        yield(file, select_strategy(file.extname[1..-1]))
      else
        raise "not found: #{file}"
      end

      return
    end

    pathname = data_directory.join(klass.to_s.underscore.pluralize)
    ext = Sowing::Configuration.config.extensions.find {|ext| Pathname("#{pathname}.#{ext}").exist? }

    if ext
      yield(Pathname("#{pathname}.#{ext}"), select_strategy(ext))
    else
      raise "not found: #{pathanme}.(#{Sowing::Configuration.config.extensions.join('|')})"
    end
  end

  def select_strategy(ext)
    strategy_klass = Sowing::Configuration.config.strategies[ext]

    if strategy_klass
      strategy_klass.new
    else
      raise "strategy not found: extension #{ext}"
    end
  end
end
