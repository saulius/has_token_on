require 'rails'
begin; require 'mongoid'; rescue LoadError; end

module HasTokenOn
  class Railtie < Rails::Railtie #:nodoc:

    generators do
      require "generators/has_token_on/config_generator"
    end

    initializer 'has_token_on' do
      HasTokenOn::Railtie.insert
    end
  end

  class Railtie
    def self.insert
      if defined?(ActiveRecord)
        ActiveSupport.on_load(:active_record) do
          require File.join(File.dirname(__FILE__), 'models/active_record')
        end
      end

      if defined? ::Mongoid
        require File.join(File.dirname(__FILE__), 'models/mongoid')
      end
    end
  end
end
