# Prerequisites Gem

A ruby gem to make it easy to test that a set of prerequisite conditions are in place.

This can be useful when using ruby as 'glue' code for sysadmin or other tasks.

## Installation

```
gem install prerequisites
```

Or add to your `Gemfile`:

```
gem "prerequisites"
```

## Usage

This example checks that:

* Environment variables "FOO" and "BAR" are set
* Environment variable "BAZ" is set to the value "whatever"
* Executables "grep", "git", and "kubectl" are in your $PATH
* The shell commands execute successfully

> NB: You should ensure that any commands you list in the `shell_commands` section have no side-effects. These are supposed to be pre-flight checks.

```
config = {
  environment_variables: [
    "FOO",
    "BAR",
    { "BAZ" => "whatever" }
  ],
  executables_in_path: [
    "grep",
    "git",
    "kubectl"
  ],
  shell_commands: [
    "echo whatever | grep what",
    "kubectl config current-context | grep myk8scluster"
  ]
}

Prerequisites.new(config).check
```

If any of these conditions are not met, the code will raise an error of class:

* Prerequisites::EnvironmentVariableError
* Prerequisites::ExecutableError
* Prerequisites::ShellCommandError

...depending on the problem.
