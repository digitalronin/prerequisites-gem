class Prerequisites
  attr_reader :config

  def initialize(config)
    @config = config
  end

  def check
    environment_variables
  end

  private

  def environment_variables
    config.dig(:environment_variables).to_a.each do |env_var|
      raise Prerequisites::EnvironmentVariableError.new("Required environment variable #{env_var} is not set") unless ENV.key?(env_var)
    end

    true
  end

end

class Prerequisites::EnvironmentVariableError < RuntimeError; end
