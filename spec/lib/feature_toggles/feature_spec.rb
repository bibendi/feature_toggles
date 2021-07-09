# frozen_string_literal: true

RSpec.describe FeatureToggles::Feature do
  subject { described_class.new(name, resolver, **metadata) }

  let(:name) { "some-feature" }
  let(:metadata) { {foo: :bar, baz: nil} }
  let(:resolver) { proc { true } }

  describe "#name" do
    it { expect(subject.name).to eq(name) }
  end

  describe "#resolver" do
    it { expect(subject.resolver).to eq(resolver) }
  end

  describe "#metadata" do
    it { expect(subject.metadata).to eq(metadata) }
  end

  describe "#[]" do
    it "returns metadata value by key" do
      expect(subject[:foo]).to eq(:bar)
      expect(subject[:baz]).to be_nil
    end
  end
end
