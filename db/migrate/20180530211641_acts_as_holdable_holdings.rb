class ActsAsHoldableHoldings < ActiveRecord::Migration[5.2]
  def change
    create_table :acts_as_holdable_holdings, force: true do |t|
      t.references :holdable, polymorphic: true, index: { name: "index_acts_as_holdable_holdings_holdable" }
      t.references :holder, polymorphic: true, index: { name: "index_acts_as_holdable_holdings_holder" }
      t.column :amount, :integer

      t.timestamps
    end
  end
end
