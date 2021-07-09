# frozen_string_literal: true

module FeatureToggles
  class Proxy
    def initialize(toggle, *args, **kwargs)
      @toggle = toggle
      @args = args
      @kwargs = kwargs
    end

    def enabled?(feature)
      toggle.enabled?(feature, *args, **kwargs)
    end

    def to_a
      toggle.to_a(*args, **kwargs)
    end

    def to_h
      toggle.to_h(*args, **kwargs)
    end

    private

    attr_reader :toggle, :args, :kwargs
  end
end
