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
      if env_var.is_a?(Hash)
        var, value = env_var.first
        check_env_var_has_value(var, value)
      else
        check_env_var_is_set(env_var)
      end
    end

    true
  end

  def check_env_var_is_set(env_var)
    unless ENV.key?(env_var)
      raise Prerequisites::EnvironmentVariableError.new(
        "Required environment variable #{env_var} is not set"
      )
    end
  end

  def check_env_var_has_value(var, value)
    unless ENV[var] == value
      raise Prerequisites::EnvironmentVariableError.new(
        "Expected environment variable #{var} to be #{value}"
      )
    end
  end

end

class Prerequisites::EnvironmentVariableError < RuntimeError; end
