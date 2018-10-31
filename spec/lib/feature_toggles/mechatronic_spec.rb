# frozen_string_literal: true

RSpec.describe FeatureToggles::Mechatronic do
  subject { described_class.new }

  describe "#feature" do
    context "when feature already exists" do
      before { subject.feature(:foo) { true } }

      it { expect { subject.feature(:foo) { false } }.to raise_error(ArgumentError) }
    end
  end

  describe "#enabled?" do
    subject do
      described_class.new do
        env "TEST_FEATURE"

        feature(:x) { false }
        feature(:y) { |a: nil| a == 0 }
      end
    end

    specify "without params", :aggregate_failures do
      expect(subject.enabled?(:x)).to eq false
      expect(subject.enabled?(:y)).to eq false
    end

    specify "with params", :aggregate_failures do
      expect(subject.enabled?(:x, a: 0)).to eq false
      expect(subject.enabled?(:y, a: 0)).to eq true
    end

    context "with env vars" do
      before { ENV["TEST_FEATURE_X"] = "1" }
      after { ENV.delete("TEST_FEATURE_X") }

      specify do
        expect(subject.enabled?(:x)).to eq true
        expect(subject.enabled?(:y)).to eq false
      end
    end
  end

  describe "#for" do
    subject do
      described_class.new do
        feature(:x) { false }
        feature(:y) { |a: nil| a == 0 }
      end.for(params)
    end

    let(:params) { {a: 0} }

    specify do
      expect(subject.enabled?(:x)).to eq false
      expect(subject.enabled?(:y)).to eq true
    end

    describe "#to_a" do
      specify do
        expect(subject.to_a).to match_array(
          [
            {feature: :x, enabled: false},
            {feature: :y, enabled: true}
          ]
        )
      end
    end

    describe "#to_h" do
      it { expect(subject.to_h).to eq(x: false, y: true) }
    end
  end
end
