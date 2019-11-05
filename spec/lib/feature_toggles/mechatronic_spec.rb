# frozen_string_literal: true

require "tempfile"

RSpec.describe FeatureToggles::Mechatronic do
  describe "definition file paths" do
    let(:file_a) do
      Tempfile.new("file_a").tap do |file|
        file.write(<<~RUBY)
          feature(:x) { false }
        RUBY

        file.flush
      end
    end

    let(:file_b) do
      Tempfile.new("file_b").tap do |file|
        file.write(<<~RUBY)
          feature(:y) { |a: nil| a == 0 }
        RUBY

        file.flush
      end
    end

    subject { described_class.new([file_a.path, file_b.path]) }

    specify "without params", :aggregate_failures do
      expect(subject.enabled?(:x)).to eq false
      expect(subject.enabled?(:y)).to eq false
    end

    specify "with params", :aggregate_failures do
      expect(subject.enabled?(:x, a: 0)).to eq false
      expect(subject.enabled?(:y, a: 0)).to eq true
    end
  end

  subject { described_class.new }

  describe "#feature" do
    context "when feature already exists" do
      before { subject.feature(:foo) { true } }

      it { expect { subject.feature(:foo) { false } }.to raise_error(ArgumentError) }
    end

    context "with provided metadata" do
      before { subject.feature(:foo, icon: :download) { true } }

      it "saves it into the feature" do
        expect(subject.first.metadata).to eq(icon: :download)
      end
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

  describe "#each" do
    subject do
      described_class.new do
        feature(:x) { false }
        feature(:y) { true }
      end
    end

    context "without block" do
      it { expect(subject.each).to be_an(Enumerator) }
      it { expect(subject.each.first).to be_an(FeatureToggles::Feature) }
    end

    context "with block" do
      it { expect(subject.map(&:name)).to eq(%i[x y]) }
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
