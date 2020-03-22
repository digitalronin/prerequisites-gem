require "spec_helper"

describe Prerequisites do
  let(:config) { {} }
  subject(:prereq) { described_class.new(config) }

  it "instantiates" do
    expect(prereq).to be_a(Prerequisites)
  end
end
