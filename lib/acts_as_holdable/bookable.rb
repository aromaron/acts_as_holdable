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
      holding_opts = options

      if holdable?
        self.holding_opts.merge!(holding_opts)
      else
        class_attribute :holding_opts
        self.holding_opts = holding_opts
  
        class_eval do
          has_many :holdings, as: :holdable, dependent: :destroy, class_name: '::ActsAsHoldable::Holding'
  
          validates :on_hand, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  
          def self.holdable?
            true
          end
        end
      end
      include Core
    end
  end
end