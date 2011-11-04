if defined?(Rails)
  require "has_token_on/railtie"
  HasTokenOn::Railtie.insert
end
