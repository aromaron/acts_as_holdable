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

  it 'new holding should have all fields set' do
    @holdable = Holdable.create(name: 'Holdable', on_hand: 4)
    new_holding = @holder.hold!(@holdable, amount: 1)
    expect(new_holding.amount).to be_present
  end

  describe 'has_many :holdings' do
    before(:each) do
      holdable1 = Holdable.create(name: 'Holdable 1', on_hand: 4)
      holdable2 = Holdable.create(name: 'Holdable 2', on_hand: 4)
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
      @holdable = Holdable.create(name: 'Holdable', on_hand: 1)
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

  describe '#unhold!' do
    before(:each) do
      @holdable = Holdable.create(name: 'Holdable', on_hand: 3)
      @holding = @holder.hold!(@holdable, amount: 2)
    end

    it 'should respond to #unhold!' do
      expect(@holder).to respond_to :unhold!
    end

    it 'should destroy a holding' do
      count = @holder.holdings.count
      @holder.unhold! @holding
      expect(@holder.holdings.count).to eq count-1
    end
  end

  describe '#hold_for', type: :job do
    before(:each) do
      @holdable = Holdable.create(name: 'Holdable', on_hand: 3)
    end

    it 'should respond to #hold_for' do
      expect(@holder).to respond_to :hold_for
    end

    it 'should create a job to destroy a holding in a time frame' do
      ActiveJob::Base.queue_adapter = :test
      count = @holder.holdings.count
      expect {
        @holder.hold_for(@holdable, duration: 1.minutes, amount: 1)
        }.to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size).by(1)
    end
  end

  describe '#confirm_holding!', type: :job do
    before(:each) do
      @holdable = Holdable.create(name: 'Holdable', on_hand: 3)
    end

    it 'should respond to #confirm_holding!' do
      expect(@holder).to respond_to :confirm_holding!
    end
  end
end