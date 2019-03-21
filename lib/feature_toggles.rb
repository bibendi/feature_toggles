# frozen_string_literal: true

require "feature_toggles/version"
require "feature_toggles/mechatronic"

module FeatureToggles
  module_function

  def build(file_paths = nil, &block)
    Mechatronic.new(file_paths, &block)
  end
end

require "feature_toggles/railtie" if defined?(Rails)
