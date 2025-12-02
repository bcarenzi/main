require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module Cinepass
  class Application < Rails::Application
    config.load_defaults 7.0
    config.action_view.form_with_generates_remote_forms = false
  end
end

