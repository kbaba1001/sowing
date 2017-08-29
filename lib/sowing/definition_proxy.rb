class Sowing::DefinitionProxy
  attr_reader :mappings

  def initialize
    @mappings = {}
  end

  def mapping(attr, &block)
    @mappings[attr.to_s] = block
  end
end
