require 'spec_helper'

describe 'Booker model' do
  before(:each) do
    @booker = Booker.new
  end

  it 'should be valid with all required fields set' do
    expect(@booker).to be_valid
  end

  it 'should save a booker' do
    expect(@booker.save).to be_truthy
  end

  describe 'has_many :bookings' do
    before(:each) do
      bookable1 = Bookable.create(name: 'Booker 1')
      bookable2 = Bookable.create(name: 'Booker 2')
      booking1 = ActsAsHoldable::Booking.create(bookable: bookable1, booker: @booker)
      booking2 = ActsAsHoldable::Booking.create(bookable: bookable2, booker: @booker)
      @booker.reload
    end

    it 'should have many bookings' do
      expect(@booker.bookings).to be_present
      expect(@booker.bookings.count).to eq 2
    end

    it 'dependent: :destroy' do
      count = ActsAsHoldable::Booking.count
      @booker.destroy!
      expect(ActsAsHoldable::Booking.count).to eq count -2
    end
  end

  describe '#book' do
    before(:each) do
      @booker.save!
      @bookable = Bookable.create(name: 'Bookable')
    end

    it 'should respond to book' do
      expect(@booker).to respond_to :book
    end

    it 'should create a new booking' do
      count = @booker.bookings.count
      new_booking = @booker.book(@bookable)

      expect(@booker.bookings.count).to eq count +1
      expect(new_booking.class.to_s).to eq 'ActsAsHoldable::Booking'
    end

    it 'should not create a new booking if it\'s not valid' do
      count = @booker.bookings.count
      @booker.book(Generic.new)
      expect(@booker.bookings.count).to eq count
    end

    it 'should return false if the booking is not valid' do
      expect(@booker.book(Generic.new)).to eq false
    end
  end

  describe '#book!' do
    before(:each) do
      @bookable = Bookable.create(name: 'Bookable')
    end

    it 'should respond to #book!' do
      expect(@booker).to respond_to :book!
    end

    it 'should create a new booking' do
      count = @booker.bookings.count
      new_booking = @booker.book!(@bookable)
      expect(@booker.bookings.count).to eq count+1
      expect(new_booking.class.to_s).to eq 'ActsAsHoldable::Booking'
    end

    it 'should raise ActiveRecord::RecordInvalid if new booking is not valid' do
      expect{ @booker.book!(Generic.new) }.to raise_error ActiveRecord::RecordInvalid
    end

    it 'should not create a new booking if it\'s not valid' do
      count = @booker.bookings.count
      begin
        @booker.book!(Generic.new)
      rescue ActiveRecord::RecordInvalid => er
      end
      expect(@booker.bookings.count).to eq count
    end
  end
end