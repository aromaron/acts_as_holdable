module ActsAsHoldable
  # Booking model. Store in host database bookings made by bookers on bookables
  class Booking < ::ActiveRecord::Base
    belongs_to :bookable, polymorphic: true
    belongs_to :booker, polymorphic: true

    validates_presence_of :bookable
    validates_presence_of :booker
    validate :bookable_is_bookable, :booker_is_booker

    private

    # Validation method. Check if the booked model is actually bookable
    def bookable_is_bookable
      return unless bookable.present? && !bookable.class.bookable?
      errors.add(:bookable, T.er('booking.must_be_bookable',
                                 model: bookable.class.to_s))
    end

    # Validation method. Check if the booker model is actually a booker
    def booker_is_booker
      return unless booker.present? && !booker.class.booker?
      errors.add(:booker, T.er('booker.must_be_booker',
                                model: booker.class.to_s))
    end
  end
end