class Sowing::Runner
  attr_reader :data_directory

  def initialize(data_directory: nil)
    @data_directory = Pathname(data_directory || Sowing::Configuration.config.default_data_directory)
    @selector = Sowing::Selector.new(@data_directory)
  end

  def create(klass, filename: nil, &block)
    file, strategy = @selector.find(klass, filename)

    create_rows(file, strategy, &block).each do |row|
      strategy.create(klass, row)
    end
  end

  def create_or_skip(klass, finding_key, filename: nil, &block)
    file, strategy = @selector.find(klass, filename)

    create_rows(file, strategy, &block).each do |row|
      strategy.create_or_skip(klass, row, finding_key)
    end
  end

  def create_or_update(klass, finding_key, filename: nil, &block)
    file, strategy = @selector.find(klass, filename)

    create_rows(file, strategy, &block).each do |row|
      strategy.create_or_update(klass, row, finding_key)
    end
  end

  private

  def create_rows(file, strategy, &block)
    proxy = Sowing::DefinitionProxy.new
    proxy.instance_exec(&block) if block_given?

    strategy.read_data(file).map {|row|
      proxy.mappings.each do |key, pproc|
        # TODO skipできるときはした方が早くなるはず
        row[key.to_s] = pproc[string_to_hash(row.fetch(key.to_s))]
      end

      row
    }
  end

  def string_to_hash(str)
    str.delete(' ').split(/[:,]/).each_slice(2).to_h
  end
end
