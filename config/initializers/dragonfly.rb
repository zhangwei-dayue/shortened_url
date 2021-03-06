require 'dragonfly'

# Configure
Dragonfly.app.configure do
  plugin :imagemagick

  secret "f324d9b4b8919568695f959d2f4e500256c9269c7d5fb4ec3365f0e77cc8c1c0"

  url_format "/media/:job/:name"

  datastore :file,
    root_path: [Rails.root.to_s.split("/release").first, "/shared/public/dragonfly/", Rails.env].join,
    server_root: Rails.root.join('public')
end

# Logger
Dragonfly.logger = Rails.logger

# Mount as middleware
Rails.application.middleware.use Dragonfly::Middleware

# Add model functionality
ActiveSupport.on_load(:active_record) do
  extend Dragonfly::Model
  extend Dragonfly::Model::Validations
end
