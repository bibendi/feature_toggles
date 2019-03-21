# frozen_string_literal: true

require "rails/railtie"

module Rails
  class << self
    delegate :features, to: "application.config"
  end
end

module FeatureToggles
  class Railtie < ::Rails::Railtie
    config.to_prepare do
      paths = []

      ::Rails.application.railties.each do |railtie|
        next unless railtie.respond_to?(:root)

        file = railtie.root.join("config", "features.rb")
        next unless file.exist?

        paths << file.to_s
      end

      # Rails-root features must be last to override engines' configuration
      file = ::Rails.root.join("config", "features.rb")
      paths << file.to_s if file.exist?

      Rails.application.config.features = FeatureToggles.build(paths)
    end
  end
end
