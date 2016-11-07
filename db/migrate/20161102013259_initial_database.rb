class InitialDatabase < ActiveRecord::Migration
  def change
    
    create_table :posts do |t|
      t.string :title
      t.text :content

      t.timestamps
    end

    create_table :users do |t|
      t.string :email
      t.text :auth_meta_data
      t.text :content

      t.timestamps
    end
  
  end
end
