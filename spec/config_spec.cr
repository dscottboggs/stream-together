require "./spec_helper"
describe StreamTogether::Config do
  it "has the right environment" do
    StreamTogether::Config.environment.testing?.should be_true
  end
end
