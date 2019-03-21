# frozen_string_literal: true

require_relative "proxy"

module FeatureToggles
  class Mechatronic
    # Which env variables should be considered truthy
    POSSIBLE_ENABLING_VALUES = %w(true on yes 1).freeze

    def initialize(definition_file_paths = nil, &block)
      @features = {}

      definition_file_paths&.each do |file|
        instance_eval(File.read(file), file)
      end

      instance_eval(&block) if block_given?
    end

    def env(val)
      @env_prefix = val
    end

    def feature(name, &block)
      raise(ArgumentError, "Flag #{name} already exists") if @features.key?(name)

      features[name] = block
    end

    def names
      features.keys
    end

    def enabled?(feature, *args)
      enabled_globally?(feature) || !!features.fetch(feature).call(*args)
    end

    def for(*args)
      Proxy.new(self, *args)
    end

    def to_a(*args)
      names.map do |feature|
        {feature: feature, enabled: enabled?(feature, *args)}
      end
    end

    def to_h(*args)
      Hash[features.map do |feature, _|
        [feature, enabled?(feature, *args)]
      end]
    end

    private

    attr_reader :features, :env_prefix

    def enabled_globally?(feature)
      env_prefix &&
        POSSIBLE_ENABLING_VALUES.include?(ENV["#{env_prefix}_#{feature.upcase}"])
    end
  end
end
