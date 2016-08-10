class Sowing::Runner
  def initialize(data_directory: nil)
    # TODO 設定ファイルに移す
    default_data_directory = 'db/seeds/'

    @data_directory = data_directory || default_data_directory
  end

  def create(klass)

  end
end
