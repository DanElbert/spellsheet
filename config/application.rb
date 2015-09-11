require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(*Rails.groups)

module Spellsheet
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.autoload_paths

    # Setting this causes times to be stored in the DB as UTC; Rails will correctly convert them
    # for use in the app
    config.time_zone = 'Central Time (US & Canada)'

    config.active_record.raise_in_transactional_callbacks = true

  end
end
