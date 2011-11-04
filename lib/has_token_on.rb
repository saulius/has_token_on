if defined?(Rails)
  require "has_token_on/rails"
  HasTokenOn::Railtie.insert
end
