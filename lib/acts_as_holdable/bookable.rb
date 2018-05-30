module ActsAsHoldable
  module Bookable
    def bookable?
      false
    end

    def acts_as_holdable(options={})
      bookable(options)
    end

    private

    def bookable(options)
      booking_opts = options

      if bookable?
        self.booking_opts.merge!(booking_opts)
      else
        class_attribute :booking_opts
        self.booking_opts = booking_opts
  
        class_eval do
          has_many :bookings, as: :bookable, dependent: :destroy, class_name: '::ActsAsHoldable::Booking'
  
          validates :capacity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  
          def self.bookable?
            true
          end
        end
      end
      include Core
    end
  end
end