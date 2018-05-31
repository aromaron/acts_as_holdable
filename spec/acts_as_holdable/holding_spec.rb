require 'spec_helper'

describe 'Holding model' do
  before(:each) do
    @holding = ActsAsHoldable::Holding.new(amount: 2)
    @holder = Holder.create!(name: 'Holder')
    @holdable = Holdable.create!(name: 'Holdable', on_hand: 1)
    @holding.holder = @holder
    @holding.holdable = @holdable
  end

  it 'should be valid with all required fields set' do
    expect(@holding).to be_valid
  end

  it 'should save a holding' do
    expect(@holding.save).to be_truthy
  end

  it 'should not be valid without a holder' do
    @holding.holder = nil
    expect(@holding).not_to be_valid
  end

  it 'should not be valid without a holdable' do
    @holding.holdable = nil
    expect(@holding.valid?).to be_falsy
  end

  it 'should not be valid with amount < 0' do
    @holding.amount = -1
    expect(@holding.valid?).to be_falsy
  end

  it 'should not be valid without amount' do
    @holding.amount = nil
    expect(@holding.valid?).to be_falsy
  end

  it 'should not be valid if holding.holder.holder? is false' do
    not_holder = Generic.create(name: 'New generic model')
    @holding.holder = not_holder
    expect(@holding).not_to be_valid
    expect(@holding.errors.messages[:holder]).to be_present
  end

  it 'should not be valid if holding.holdable.holdable? is false' do
    holdable = Generic.create(name: 'New generic model')
    @holding.holdable = holdable
    expect(@holding).not_to be_valid
    expect(@holding.errors.messages[:holdable]).to be_present
  end

  it 'should belong to holder' do
    expect(@holding.holder.id).to eq @holder.id
  end

  it 'should belong to holdable' do
    expect(@holding.holdable.id).to eq @holdable.id
  end

  describe 'update on_hold counters' do
    it 'should to update holdables on_hand' do
      holdable1 = Holdable.create!(name: 'Holdable', on_hand: 3)
      @holder.hold!(holdable1, amount: 2)
      expect(holdable1.on_hold).to eq 2
    end
  end

  describe 'dont update on_hold counter' do
    before(:each) do
      Holdable.holding_opts[:on_hold_track] = false
      Holdable.initialize_acts_as_holdable_core
    end

    after(:all) do
      Holdable.holding_opts = {}
      Holdable.initialize_acts_as_holdable_core
    end

    it 'should not update holdables on_hand if on_hold_track is set to false' do
      holdable2 = Holdable.create!(name: 'Holdable', on_hand: 3)
      @holder.hold!(holdable2, amount: 2)
      expect(holdable2.on_hold).to eq nil
    end
  end
end