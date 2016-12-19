class MovePropertiesOutOfHashPost < ActiveRecord::Migration
  def change
    add_column :posts, :subtitle, :string
    add_column :posts, :body, :text
    add_column :posts, :author, :string
    add_column :posts, :user_id, :integer
  end
end
