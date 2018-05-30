module ActsAsHoldable
  module Holder
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def acts_as_holder(opts={})
        class_eval do
          has_many :holdings, as: :holder, dependent: :destroy, class_name: '::ActsAsHoldable::Holding'
        end

        include ActsAsHoldable::Holder::InstanceMethods
        extend ActsAsHoldable::Holder::SingletonMethods
      end

      def holder?
        false
      end
    end

    module InstanceMethods

      def hold!(holdable, opts={})
        holdable.class.validate_holding_options!(opts) if holdable.class.holdable?
        holding = ActsAsHoldable::Holding.create!(holder: self, holdable: holdable, amount: opts[:amount])
        holdable.reload
        holding
      end

      def holder?
        self.class.holder?
      end
    end

    module SingletonMethods
      def holder?
        true
      end
    end
  end
end