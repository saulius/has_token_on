require 'rails'

module HasTokenOn
  class Engine < ::Rails::Engine #:nodoc:

    generators do
      require "generators/has_token_on/config_generator"
    end

    initializer :load_models do
      ::ActiveSupport.on_load(:active_record) do
        require File.join(File.dirname(__FILE__), 'models/active_record')
      end
    end
  end
end
