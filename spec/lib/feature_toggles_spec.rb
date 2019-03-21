# frozen_string_literal: true

RSpec.describe FeatureToggles do
  it "has a version number" do
    expect(FeatureToggles::VERSION).not_to be nil
  end

  describe ".build" do
    context "by default" do
      it "builds a mechatronic instance" do
        expect(FeatureToggles.build).to be_a(FeatureToggles::Mechatronic)
      end
    end

    context "when have file paths" do
      it "sends path as argument" do
        expect(FeatureToggles::Mechatronic).to receive(:new).with(["/foo/bar.rb"])

        FeatureToggles.build(["/foo/bar.rb"])
      end
    end
  end
end
