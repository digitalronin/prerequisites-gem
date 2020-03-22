class Prerequisites
  attr_reader :config

  def initialize(config)
    @config = config
  end

  def check
    true
  end

end
