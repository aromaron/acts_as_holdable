require 'spec_helper'

describe 'Bookable model' do
  before(:each) do
    @bookable = Bookable.create!(name: 'Bookable')
  end

  it 'should be valid with all required fields set' do
    expect(@bookable).to be_valid
  end

  it 'should save a bookable' do
    expect(@bookable.save).to be_truthy
  end

  describe 'has_many :bookings' do
    before(:each) do
      booker1 = Booker.create(name: 'Booker 1')
      booker2 = Booker.create(name: 'Booker 2')
      booking1 = ActsAsHoldable::Booking.create(booker: booker1, bookable: @bookable)
      booking2 = ActsAsHoldable::Booking.create(booker: booker1, bookable: @bookable)
      @bookable.reload
    end

    it 'should have many bookings' do
      expect(@bookable.bookings).to be_present
      expect(@bookable.bookings.count).to eq 2
    end

    it 'dependent: :destroy' do
      count = ActsAsHoldable::Booking.count
      @bookable.destroy!
      expect(ActsAsHoldable::Booking.count).to eq count -2
    end
  end
end