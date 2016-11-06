class AddUser < ActiveRecord::Migration
  def change

    create_table :users do |t|
      t.string :firstname
      t.string :lastname
      t.string :age
      t.string :email
      t.string :phone
      t.string :gender
      t.boolean :block
      t.text :auth_meta_data

      t.timestamps
    end
  
  end
end
