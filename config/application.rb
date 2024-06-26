require_relative "boot"

require "rails/all"
require "jp_prefecture"
# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Foodtravel0409
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1
    config.i18n.default_locale = :ja
    config.i18n.load_path+=Dir[Rails.root.join('config','locales','**','*.yml').to_s]
    config.action_view.field_error_proc = Proc.new { |html_tag, instance| html_tag }
  end
end
