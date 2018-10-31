# frozen_string_literal: true

RSpec.describe FeatureToggles do
  it "has a version number" do
    expect(FeatureToggles::VERSION).not_to be nil
  end

  it "builds a mechatronic instance" do
    expect(FeatureToggles.build).to be_a(FeatureToggles::Mechatronic)
  end
end
