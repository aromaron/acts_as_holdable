require 'spec_helper'

describe 'acts_as_holder' do
  it "should provide a class method 'holder?' that is false for not holder models" do
    expect(NotHolder).not_to be_holder
  end

  describe 'Holder Method Generation' do
    before :each do
      NotHolder.acts_as_holder
      @holder = NotHolder.new
    end

    it "should respond 'true' to holder?" do
      expect(@holder.class).to be_holder
    end
  end

  describe 'class configured as Holder' do
    before(:each) do
      @holder = Holder.new
    end

    it 'should add #holder? query method to the class-side' do
      expect(Holder).to respond_to(:holder?)
    end

    it 'should return true from the class-side #holder?' do
      expect(Holder.holder?).to be_truthy
    end

    it 'should return false from the base #holder?' do
      expect(ActiveRecord::Base.holder?).to be_falsy
    end

    it 'should add #holder? query method to the instance-side' do
      expect(@holder).to respond_to(:holder?)
    end

    it 'should add #holder? query method to the instance-side' do
      expect(@holder.holder?).to be_truthy
    end
  end

  describe 'Reloading' do
    it 'should save a model instantiated by Model.find' do
      holder = Holder.create!(name: 'Holder')
      found_holder = Holder.find(holder.id)
      expect(found_holder.save).to eq true
    end
  end
end