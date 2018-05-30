require 'active_record'
require 'acts_as_holdable/engine'

module ActsAsHoldable
  extend ActiveSupport::Autoload

  autoload :T
  autoload :Holdable
  autoload :Holder
  autoload :Holding

  autoload_under 'holdable' do
      autoload :Core
    end

  class InitializationError < StandardError
    def initialize(model, message)
      super "Error initializing acts_as_bookable on #{model.to_s} - " + message
    end
  end

  class OptionsInvalid < StandardError
    def initialize(model, message)
      super "Error validating options for #{model.to_s} - " + message
    end
  end

  class AvailabilityError < StandardError
  end
end

ActiveSupport.on_load(:active_record) do
  extend ActsAsHoldable::Holdable
  include ActsAsHoldable::Holder
end
