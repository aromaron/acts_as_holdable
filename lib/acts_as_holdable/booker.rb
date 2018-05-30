module ActsAsHoldable
  module Booker
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def acts_as_booker(opts={})
        class_eval do
          has_many :bookings, as: :booker, dependent: :destroy, class_name: '::ActsAsHoldable::Booking'
        end

        include ActsAsHoldable::Booker::InstanceMethods
        extend ActsAsHoldable::Booker::SingletonMethods
      end

      def booker?
        false
      end
    end

    module InstanceMethods

      def book!(bookable)
        booking = ActsAsHoldable::Booking.create!(booker: self, bookable: bookable)
        bookable.reload
        booking
      end

      def book(bookable)
        begin
          book!(bookable)
        rescue ActiveRecord::RecordInvalid => er
          false
        end
      end

      def booker?
        self.class.booker?
      end
    end

    module SingletonMethods
      def booker?
        true
      end
    end
  end
end