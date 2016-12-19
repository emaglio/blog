class MovePropertiesFromHashUser < ActiveRecord::Migration
  def change
    add_column :users, :firstname, :string
    add_column :users, :lastname, :string
    add_column :users, :gender, :string
    add_column :users, :phone, :string
    add_column :users, :age, :integer
    add_column :users, :block, :boolean
  end
end
