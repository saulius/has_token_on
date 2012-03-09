begin; require 'simple_uuid'; rescue LoadError; end

module HasTokenOn

  class LibraryNotPresent < StandardError #:nodoc:
  end

  module Base
    extend ActiveSupport::Concern

    included do
      after_initialize { |record| create_tokens(record, :initialize) }
      before_create { |record| create_tokens(record, :create) }
      before_update { |record| create_tokens(record, :update) }
    end

    module ClassMethods
      # = has_token_on
      #
      # Simple yet customizable token generator
      #
      # == Declaration
      #
      # Declare this in your model to generate token on specified attributes. Declaration can either be:
      #
      # For single token with configuration:
      #
      #   has_token_on :slug, :length => 3
      #
      # For multiple tokens with same configuration:
      #
      #   has_token_on [:slug, :permalink], :length => 3
      #
      # For multiple tokens with individual configurations:
      #
      #   has_token_on :slug, :length => 3
      #   has_token_on :permalink, :length => 5
      #
      # Or using single hash:
      #
      #   has_token_on :slug => { :length => 3 }, :permalink => { :length => 5 }
      #
      # == Options
      #
      # * :length - length of the token to generate
      # * :prepend - prepend something to the token string
      # * :append - append something to the token string
      # * :unique - should the token be unique among other record's tokens
      # * :if - sets the token only if Proc passed to this option returns true
      # * :on - specify when to set the token, possible options are: :initialize, :create, :update
      # * :seed - elements or functions used to generate hash. Possible options:
      #   * :securerandom (default) uses ActiveSupport::SecureRandom.hex
      #   * :guid uses simple_uuid gem (add it to your Gemfile!).
      #     Length is ignored in this case. GUIDs are 36 characters long.
      #   * ('a'..'z') a Range. Mixes the range elements up to specified length.
      #   * lambda { 2 * 2 } a Proc. Executes proc, length param is ignored in this case.
      #
      def has_token_on(*args)
        @tokens ||= {}

        case args.first
          when String, Symbol
            @tokens[args.first] = args.last.kind_of?(Symbol) ? {} : args.last
          when Hash
            args.first.each { |token, config|
              @tokens[token] = config
            }
          when Array
            args.first.each { |token|
              @tokens[token] = args.last
            }
        end
      end

      # Returns Hash of tokens that are configured for specific class
      def tokens
        @tokens
      end

    end

    private

    def create_tokens(record, callback)
      return unless any_tokens?

      tokens_to_build_on(callback).each do |token, config|
        if !config.has_key?(:if) or (config.has_key?(:if) and config[:if].call(record))
          begin
            self[token] = build_token(config)
          end while (config.has_key?(:unique) and config[:unique]) and token_is_nonunique?(token)
        end
      end
    end

    def build_token(config)
      defaults = { :length => 16, :prepend => "", :append => "", :seed => :securerandom }
      config = defaults.merge(config)

      return [config[:prepend],
              build_from_seed(config),
              config[:append]
            ].join
    end

    def build_from_seed(config)
      case config[:seed]
        when Symbol
          if config[:seed] == :securerandom
            SecureRandom.hex(config[:length]).first(config[:length])
          elsif config[:seed] == :guid
            if simple_uuid_present?
              ::SimpleUUID::UUID.new.to_guid
            else
              raise LibraryNotPresent, "Supporting library SimpleUUID is not present. Add it to your Gemfile?"
            end
          end
        when Range
          chars = config[:seed].to_a
          (0...config[:length]).collect { chars[Kernel.rand(chars.length)] }.join
        when Proc
          config[:seed].call.to_s
      end
    end

    def any_tokens?
      self.class.tokens && self.class.tokens.any?
    end

    def tokens_to_build_on(callback)
      self.class.tokens.select{ |token, config|
        if config.has_key?(:on)
          config[:on].include?(callback)
        else
          # if user didn't specify :on we set token before record create
          callback == :create
        end
      }
    end

    def simple_uuid_present?
      defined? ::SimpleUUID
    end
  end
end
