# frozen_string_literal: true

require "feature_toggles/version"
require "feature_toggles/mechatronic"

module FeatureToggles
  module_function

  def build(&block)
    Mechatronic.new(&block)
  end
end
