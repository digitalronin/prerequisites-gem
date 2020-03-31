require "spec_helper"

describe Prerequisites, "shell commands" do
  let(:config) {
    {
      shell_commands: shell_commands,
    }
  }

  subject(:prereq) { described_class.new(config) }

  context "when all commands succeed" do
    let(:shell_commands) { ["true"] }
    specify { expect(prereq.check).to be(true) }
  end

  context "when all commands fail" do
    let(:shell_commands) { ["false"] }

    it "fails" do
      expect {
        prereq.check
      }.to raise_error(Prerequisites::ShellCommandError)
    end
  end

  context "when any commands fail" do
    let(:shell_commands) { ["true", "false", "true"] }

    it "fails" do
      expect {
        prereq.check
      }.to raise_error(Prerequisites::ShellCommandError)
    end
  end
end
