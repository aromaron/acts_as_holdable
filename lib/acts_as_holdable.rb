require 'active_record'
require 'acts_as_holdable/engine'

module ActsAsHoldable
  extend ActiveSupport::Autoload

  autoload :T
  autoload :Bookable
  autoload :Booker
  autoload :Booking

  autoload_under 'bookable' do
      autoload :Core
    end
  

end

ActiveSupport.on_load(:active_record) do
  extend ActsAsHoldable::Bookable
  include ActsAsHoldable::Booker
end
