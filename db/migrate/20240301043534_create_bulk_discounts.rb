class CreateBulkDiscounts < ActiveRecord::Migration[7.1]
  def change
    create_table :bulk_discounts do |t|
      t.references :merchant, null: false, foreign_key: true
      t.string :name
      t.integer :percentage
      t.integer :quantity_threshold

      t.timestamps
    end
  end
end
