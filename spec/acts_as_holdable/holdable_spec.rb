require 'spec_helper'

describe 'Holdable model' do
  before(:each) do
    @holdable = Holdable.create!(name: 'Holdable', on_hand: 1)
  end

  describe 'conditional validations' do
    it 'should be valid with all required fields set' do
      expect(@holdable).to be_valid
    end

    it 'should save a holdable' do
      expect(@holdable.save).to be_truthy
    end

    describe 'when on_hand is required' do
      before(:each) do
        Holdable.holding_opts[:on_hand_type] = :open
        Holdable.initialize_acts_as_holdable_core
      end

      after(:all) do
        Holdable.holding_opts = {}
        Holdable.initialize_acts_as_holdable_core
      end

      it 'should not be valid with on_hand < 0 if on_hand is required' do
        @holdable.on_hand = -1
        expect(@holdable.valid?).to be_falsy
      end

      it 'should not be valid without a on_hand' do
        @holdable.on_hand = nil
        expect(@holdable.valid?).to be_falsy
      end
    end

    describe 'when on_hand is not required' do
      before(:each) do
        Holdable.holding_opts[:on_hand_type] = :none
        Holdable.initialize_acts_as_holdable_core
      end

      after(:all) do
        Holdable.holding_opts = {}
        Holdable.initialize_acts_as_holdable_core
      end

      it 'should be valid with on_hand < 0' do
        @holdable.on_hand = -1
        expect(@holdable.valid?).to be_truthy
      end
  
      it 'should validate without on_hand if it\'s not required' do
        @holdable.on_hand = nil
        expect(@holdable.valid?).to be_truthy
      end
    end
  end

  describe 'has_many :holdings' do
    before(:each) do
      holder1 = Holder.create(name: 'Holder 1')
      holder2 = Holder.create(name: 'Holder 2')
      holding1 = ActsAsHoldable::Holding.create(holder: holder1, holdable: @holdable, amount: 1)
      holding2 = ActsAsHoldable::Holding.create(holder: holder1, holdable: @holdable, amount: 2)
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