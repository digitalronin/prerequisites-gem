require "spec_helper"

describe Prerequisites, "environment variables" do
  let(:environment_variables) { nil }

  let(:config) {
    {
      environment_variables: environment_variables,
    }
  }

  subject(:prereq) { described_class.new(config) }

  it "instantiates" do
    expect(prereq).to be_a(Prerequisites)
  end

  it "checks" do
    expect(prereq.check).to be(true)
  end

  context "when a required env. var. is set" do
    let(:environment_variables) { ["FOO"] }

    before do
      allow(ENV).to receive(:key?).with("FOO").and_return(true)
    end

    it "checks" do
      expect(prereq.check).to be(true)
    end
  end

  context "when a required env. var. is not set" do
    let(:environment_variables) { ["FOO"] }

    it "raises an error" do
      expect {
        prereq.check
      }.to raise_error(Prerequisites::EnvironmentVariableError)
    end
  end
end
