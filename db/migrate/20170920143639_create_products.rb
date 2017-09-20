class CreateProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :products, id: :uuid do |t|
      t.string :name,            null: false
      t.text :description,       null: false
      t.integer :price_in_cents, null: false

      t.timestamps
    end
  end
end
