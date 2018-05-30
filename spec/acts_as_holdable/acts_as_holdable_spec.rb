require 'spec_helper'

describe 'acts_as_holdable' do
  it "should provide a class method 'holdable?' that is false for unholdable models" do
    expect(Unholdable).not_to be_holdable
  end

  describe 'Holdable Method Generation' do
    before :each do
      Unholdable.acts_as_holdable
      @holdable = Unholdable.new
    end

    it "should respond 'true' to holdable?" do
      expect(@holdable.class).to be_holdable
    end
  end

  describe 'class configured as Holdable' do
    before(:each) do
      @holdable = Holdable.new
    end

    it 'should add #holdable? query method to the class-side' do
      expect(Holdable).to respond_to(:holdable?)
    end

    it 'should return true from the class-side #holdable?' do
      expect(Holdable.holdable?).to be_truthy
    end

    it 'should return false from the base #holdable?' do
      expect(ActiveRecord::Base.holdable?).to be_falsy
    end
  end

  describe 'Reloading' do
    it 'should save a model instantiated by Model.find' do
      holdable = Holdable.create!(name: 'Holdable', on_hand: 1)
      found_holdable = Holdable.find(holdable.id)
      expect(found_holdable.save).to eq true
    end
  end
end