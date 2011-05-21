# HasTokenOn

Simple yet customizable token generator for Rails 3

# Features

* Any number of tokens per model
* Customizable length of each token
* Prepending/Appending to token
* Condition checking when setting the token
* Setting token on various callbacks namely initialization, creation, updating
* Customizable seed to generate token from

# Examples

## Initialization

* Single token
      has_token_on :slug, :length => 3
* Multiple tokens, same configuration
      has_token_on [:slug, :permalink], :length => 3
* Multiple tokens with individual configuration
      has_token_on :slug, :length => 3
      has_token_on :permalink, :length => 5
* .. or using single hash
      has_token_on :slug => { :length => 3 }, :permalink => { :length => 5 }

## Options

Options are as follows:

* :length - token length. Default - 16.
      has_token_on :slug, length => 3
* :prepend - prepend something to the beginning of the token. Default - none.
      has_token_on :slug, :prepend => "private"
* :append - append something to the back of the token. Default - none.
      has_token_on :slug, :append => "ending"
* :unique - ensure that tokens is unique (checking is performed in the app logic). Default - false.
      has_token_on :slug, :unique => true
* :if - generate token only if provided condition is met. Default - none.
      has_token_on :slug, :if => lambda { |record| record.private? }
* :on - generates token on certain time: :initialize, :create (default), :update.
      has_token_on :slug, :on => :initialize
* :seed - elements or functions that are used to generate hash. Options:
  * :securerandom - uses ActiveSupport::SecureRandom.hex (default)
        has_token_on :slug, :seed => :securerandom
  * :guid - uses simple_uuid gem. You should add it to your Gemfile. 36 characters long GUID. Length param is ignored.
        has_token_on :slug, :seed => :guid
  * ('a'..'z') - a Range. Mixes the range elements up to specified length.
        has_token_on :slug, :seed => ('a'..'z')
  * lambda { 2 * 2 } - a Proc. Executes proc. Length param is ignored.
        has_token_on :slug, :seed => lambda { 2 * 2 }

## Generator

has_token_on comes with a generator that generates a migration for token.

    Usage:
      rails generate has_token_on:config MODEL NAME [options]

    Options:
      [--length=N]             # Token length
      [--create-on=CREATE_ON]  # Create on: initialize, create, update
      [--with-index]           # Index the token field (default: es)
                               # Default: true
      [--unique]               # Is token unique?
                               # Default: true

    Runtime options:
      -f, [--force]    # Overwrite files that already exist
      -p, [--pretend]  # Run but do not make any changes
      -q, [--quiet]    # Supress status output
      -s, [--skip]     # Skip files that already exist

    Description:
      Generates a migration that adds token field a model. Modifies model code.

    Example:
      rails g has_token_on:config paste token

# Testing

Tested on Mac OS X with Ruby 1.9.2 p180.

* Enter gem directory
* Execute
      bundle
      rake

You may use [guard](https://github.com/guard) for continuous testing
    bundle exec guard

**NB** it will try to install some OSX specific gems like 'rb-fsevent'.

# License

Copyright (c) 2011 Saulius Grigaliunas, released under the MIT license
