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
  

end

ActiveSupport.on_load(:active_record) do
  extend ActsAsHoldable::Holdable
  include ActsAsHoldable::Holder
end
