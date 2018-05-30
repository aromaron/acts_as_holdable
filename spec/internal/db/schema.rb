# frozen_string_literal: true

ActiveRecord::Schema.define do
  # Set up any tables you need to exist for your test suite that don't belong
  # in migrations.

  create_table :holdables, force: true do |t|
    t.column :name, :string
    t.column :on_hand, :integer
  end

  create_table :unholdables, force: true do |t|
    t.column :name, :string
  end

  create_table :holders, force: true do |t|
    t.column :name, :string
  end

  create_table :not_holders, force: true do |t|
    t.column :name, :string
  end

  create_table :generics, force: true do |t|
    t.column :name, :string
  end

  create_table :acts_as_holdable_holdings, force: true do |t|
    t.column :name, :string
    t.references :holdable, polymorphic: true, index: { name: "index_acts_as_holdable_holdings_holdable" }
    t.references :holder, polymorphic: true, index: { name: "index_acts_as_holdable_holdings_holder" }
    t.column :amount, :integer
  end
end
