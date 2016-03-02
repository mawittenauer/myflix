require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(:default, Rails.env)

module Myflix
  class Application < Rails::Application
    config.encoding = "utf-8"
    config.filter_parameters += [:password]
    config.active_support.escape_html_entities_in_json = true

    config.assets.enabled = true
    config.generators do |g|
      g.orm :active_record
      g.template_engine :haml
    end
  end
end

Raven.configure do |config|
  config.dsn = 'https://d18e280c3a6a4ac78277e7d4a354b198:c829521f38334b599bc690da1cd2602b@app.getsentry.com/68943'
  config.environments = ['staging', 'production']
end
