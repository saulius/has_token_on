require 'has_token_on/models/base'
require 'mongoid'

module HasTokenOn
  module Mongoid
    extend ActiveSupport::Concern
    include HasTokenOn::Base

    private

    def token_is_nonunique?(token)
      self.class.first(:conditions => { token => self[token] }).present?
    end
  end
end

::Mongoid::Document.send :include, HasTokenOn::Mongoid
