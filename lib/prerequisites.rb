require "open3"

class Prerequisites
  attr_reader :config

  def initialize(config)
    @config = config
  end

  def check
    environment_variables
    executables_in_path
    shell_commands
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

  def executables_in_path
    config.dig(:executables_in_path).to_a.each do |executable|
      check_executable(executable)
    end

    true
  end

  def shell_commands
    config.dig(:shell_commands).to_a.each do |cmd|
      _, _, status = Open3.capture3(cmd)

      unless status.success?
        raise Prerequisites::ShellCommandError.new(
          "Shell command check failed: #{cmd}"
        )
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

  def check_executable(executable)
    _, _, status = Open3.capture3("which #{executable}")

    unless status.success?
      raise Prerequisites::ExecutableError.new(
        "Required executable #{executable} not found in path"
      )
    end
  end
end

class Prerequisites::EnvironmentVariableError < RuntimeError; end
class Prerequisites::ExecutableError < RuntimeError; end
class Prerequisites::ShellCommandError < RuntimeError; end
