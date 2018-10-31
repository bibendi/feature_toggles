# frozen_string_literal: true

module FeatureToggles
  class Proxy
    def initialize(toggle, *args)
      @toggle = toggle
      @args = args
    end

    def enabled?(feature)
      toggle.enabled?(feature, *args)
    end

    def to_a
      toggle.to_a(*args)
    end

    def to_h
      toggle.to_h(*args)
    end

    private

    attr_reader :toggle, :args
  end
end
