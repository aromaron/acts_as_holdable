# frozen_string_literal: true

require 'active_record'
require 'acts_as_holdable/engine'
require 'active_job'
require 'sidekiq-status'

module ActsAsHoldable
  extend ActiveSupport::Autoload

  autoload :T
  autoload :Holdable
  autoload :Holder
  autoload :Holding
  autoload :DbUtils

  autoload_under 'holdable' do
    autoload :Core
  end

  class InitializationError < StandardError
    def initialize(model, message)
      super "Error initializing acts_as_holdable on #{model} - " + message
    end
  end

  class OptionsInvalid < StandardError
    def initialize(model, message)
      super "Error validating options for #{model} - " + message
    end
  end

  class AvailabilityError < StandardError
  end
end

ActiveSupport.on_load(:active_record) do
  extend ActsAsHoldable::Holdable
  include ActsAsHoldable::Holder
end
