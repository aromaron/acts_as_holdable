require 'spec_helper'

describe 'Holdable model' do
  before(:each) do
    @holdable = Holdable.create!(name: 'Holdable', capacity: 1)
  end

  it 'should be valid with all required fields set' do
    expect(@holdable).to be_valid
  end

  it 'should save a holdable' do
    expect(@holdable.save).to be_truthy
  end

  describe 'has_many :holdings' do
    before(:each) do
      holder1 = Holder.create(name: 'Holder 1')
      holder2 = Holder.create(name: 'Holder 2')
      holding1 = ActsAsHoldable::Holding.create(holder: holder1, holdable: @holdable)
      holding2 = ActsAsHoldable::Holding.create(holder: holder1, holdable: @holdable)
      @holdable.reload
    end

    it 'should have many holdings' do
      expect(@holdable.holdings).to be_present
      expect(@holdable.holdings.count).to eq 2
    end

    it 'dependent: :destroy' do
      count = ActsAsHoldable::Holding.count
      @holdable.destroy!
      expect(ActsAsHoldable::Holding.count).to eq count -2
    end
  end
end