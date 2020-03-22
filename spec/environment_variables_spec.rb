require "spec_helper"

describe Prerequisites, "environment variables" do
  let(:environment_variables) { ["FOO"] }

  let(:config) {
    {
      environment_variables: environment_variables,
    }
  }

  subject(:prereq) { described_class.new(config) }

  context "when no env. vars. are required" do
    let(:environment_variables) { nil }

    specify { expect(prereq.check).to be(true) }
  end

  context "when a required env. var. is set" do
    before do
      allow(ENV).to receive(:key?).with("FOO").and_return(true)
    end

    specify { expect(prereq.check).to be(true) }
  end

  context "when a required env. var. is not set" do
    it "raises an error" do
      expect {
        prereq.check
      }.to raise_error(Prerequisites::EnvironmentVariableError)
    end
  end

  context "when a required env. var. has the right value" do
    let(:environment_variables) { [{"FOO" => "bar"}] }

    before do
      allow(ENV).to receive(:[]).with("FOO").and_return("bar")
    end

    specify { expect(prereq.check).to be(true) }
  end

  context "when a required env. var. has the wrong value" do
    let(:environment_variables) { [{"FOO" => "bar"}] }

    before do
      allow(ENV).to receive(:[]).with("FOO").and_return("wrong value")
    end

    it "raises an error" do
      expect {
        prereq.check
      }.to raise_error(Prerequisites::EnvironmentVariableError)
    end
  end
end
