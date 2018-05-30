# frozen_string_literal: true

ActiveRecord::Schema.define do
  # Set up any tables you need to exist for your test suite that don't belong
  # in migrations.

  create_table :bookables, force: true do |t|
    t.column :name, :string
  end

  create_table :unbookables, force: true do |t|
    t.column :name, :string
  end

  create_table :bookers, force: true do |t|
    t.column :name, :string
  end

  create_table :not_bookers, force: true do |t|
    t.column :name, :string
  end

  create_table :generics, force: true do |t|
    t.column :name, :string
  end

  create_table :bookings, force: true do |t|
    t.column :name, :string
    t.references :bookable, polymorphic: true
    t.references :booker, polymorphic: true
    t.column :booker_type, :string
    t.column :bookable_type, :integer
  end
end
