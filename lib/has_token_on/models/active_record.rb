require 'has_token_on/models/base'

module HasTokenOn
  module ActiveRecord
    extend ActiveSupport::Concern
    include HasTokenOn::Base

    private

    def token_is_nonunique?(token)
      self.class.exists?(token => self[token])
    end
  end
end

::ActiveRecord::Base.send :include, HasTokenOn::ActiveRecord
