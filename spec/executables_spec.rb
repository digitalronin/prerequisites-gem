require "spec_helper"

describe Prerequisites, "executables" do
  let(:cmd_success) { double(success?: true) }
  let(:cmd_fail) { double(success?: false) }

  let(:executables_in_path) { ["myprogram"] }

  let(:config) {
    {
      executables_in_path: executables_in_path,
    }
  }

  subject(:prereq) { described_class.new(config) }

  let(:cmd_return) { ["", "", cmd_result] }

  before do
    expect(Open3).to receive(:capture3).with("which myprogram").and_return(cmd_return)
  end

  context "when a required executable is in the path" do
    let(:cmd_result) { cmd_success }

    specify { expect(prereq.check).to be(true) }
  end

  context "when a required executable is not in the path" do
    let(:cmd_result) { cmd_fail }

    it "fails" do
      expect {
        prereq.check
      }.to raise_error(Prerequisites::ExecutableError)
    end
  end
end
