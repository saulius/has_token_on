require 'rails/generators'
require 'rails/generators/migration'
require 'rails/generators/active_record/migration'

module HasTokenOn
  class ConfigGenerator < ::Rails::Generators::Base
    include ::Rails::Generators::Migration
    extend ::ActiveRecord::Generators::Migration

    source_root File.expand_path(File.join(File.dirname(__FILE__), 'templates'))

    argument :model, :type => :string, :required => true, :desc => "Model to put token on to"
    argument :name, :type => :string, :required => true, :desc => "Token name"

    class_option :length, :type => :numeric, :desc => "Token length"
    class_option :create_on, :type => :string, :desc => "Create on: initialize, create, update"
    class_option :with_index, :type => :boolean, :default => true, :desc => "Index the token field (default: es)"
    class_option :unique, :type => :boolean, :default => true, :desc => "Is token unique?"

    desc <<DESC
Description:
  Generates a migration that adds token field a model. Modifies model code.

Example:
  rails g has_token_on:config paste token
DESC

    def create_migration_file
      migration_template "create_token.rb.erb",
                          "db/migrate/create_#{self.model}_#{self.name}.rb",
                          :assigns => { :model => self.model, :name => self.name  }
    end

  end
end

