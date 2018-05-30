require 'spec_helper'

describe 'Holder model' do
  before(:each) do
    @holder = Holder.new
  end

  it 'should be valid with all required fields set' do
    expect(@holder).to be_valid
  end

  it 'should save a holder' do
    expect(@holder.save).to be_truthy
  end

  describe 'has_many :holdings' do
    before(:each) do
      holdable1 = Holdable.create(name: 'Holdable 1', capacity: 1)
      holdable2 = Holdable.create(name: 'Holdable 2', capacity: 2)
      holding1 = ActsAsHoldable::Holding.create(holdable: holdable1, holder: @holder, amount: 1)
      holding2 = ActsAsHoldable::Holding.create(holdable: holdable2, holder: @holder, amount: 1)
      @holder.reload
    end

    it 'should have many holdings' do
      expect(@holder.holdings).to be_present
      expect(@holder.holdings.count).to eq 2
    end

    it 'dependent: :destroy' do
      count = ActsAsHoldable::Holding.count
      @holder.destroy!
      expect(ActsAsHoldable::Holding.count).to eq count -2
    end
  end

  describe '#hold!' do
    before(:each) do
      @holdable = Holdable.create(name: 'Holdable', capacity: 1)
    end

    it 'should respond to #hold!' do
      expect(@holder).to respond_to :hold!
    end

    it 'should create a new holding' do
      count = @holder.holdings.count
      new_holding = @holder.hold!(@holdable, amount: 1)
      expect(@holder.holdings.count).to eq count +1
      expect(new_holding.class.to_s).to eq 'ActsAsHoldable::Holding'
    end

    it 'should raise ActiveRecord::RecordInvalid if new holding is not valid' do
      expect{ @holder.hold!(Generic.new) }.to raise_error ActiveRecord::RecordInvalid
    end

    it 'should not create a new holding if it\'s not valid' do
      count = @holder.holdings.count
      begin
        @holder.hold!(Generic.new)
      rescue ActiveRecord::RecordInvalid => er
      end
      expect(@holder.holdings.count).to eq count
    end
  end
end