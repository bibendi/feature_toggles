# frozen_string_literal: true

module FeatureToggles
  class Feature
    def initialize(name, resolver, **metadata)
      @name = name
      @resolver = resolver
      @metadata = metadata
    end

    attr_reader :name, :resolver, :metadata

    def [](key)
      @metadata[key]
    end
  end
end
