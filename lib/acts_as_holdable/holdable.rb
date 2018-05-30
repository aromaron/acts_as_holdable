module ActsAsHoldable
  module Holdable
    def holdable?
      false
    end

    def acts_as_holdable(options={})
      holdable(options)
    end

    private

    def holdable(options)
      if holdable?
        self.holding_opts = options
      else
        class_attribute :holding_opts
        self.holding_opts = options
  
        class_eval do
          has_many :holdings, as: :holdable, dependent: :destroy, class_name: '::ActsAsHoldable::Holding'
  
          validates :capacity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  
          def self.holdable?
            true
          end
        end
      end
      include Core
    end
  end
end