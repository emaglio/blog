class AddItemAsModel < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.integer :post_id
      t.integer :position
      t.text :body
      t.text :subtitle
      t.string :type

      t.timestamps
    end
  end
end
