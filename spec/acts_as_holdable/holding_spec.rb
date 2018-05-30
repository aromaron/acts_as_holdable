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
end