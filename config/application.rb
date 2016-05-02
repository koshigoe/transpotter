require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
# require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Transpotter
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true

    config.generators do |g|
      g.active_record migration: false
      g.test_framework :rspec, controller_specs: false
    end

    ActiveModel::Serializer.config.adapter = :json_api
    ActiveModel::Serializer.config.key_transform = :camel_lower
    ActiveModel::Serializer.config.jsonapi_resource_type = :singular

    config.x.proftpd_account.default_uid = 1000
    config.x.proftpd_account.default_gid = 1000
    config.x.proftpd_account.default_homedir = '/home/vagrant'
  end
end
