# frozen_string_literal: true

require "feature_toggles/railtie"

RSpec.describe FeatureToggles::Railtie do
  subject { Rails.features }

  specify "without params", :aggregate_failures do
    expect(subject.enabled?(:x)).to eq false
    expect(subject.enabled?(:y)).to eq false
    expect(subject.enabled?(:foo_x)).to eq false
  end

  specify "with params", :aggregate_failures do
    expect(subject.enabled?(:x, a: 0)).to eq false
    expect(subject.enabled?(:y, a: 0)).to eq true
    expect(subject.enabled?(:foo_x, a: 0)).to eq true
  end
end
