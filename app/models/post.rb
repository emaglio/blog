class Post < ActiveRecord::Base 
  belongs_to :user
  serialize :content, Array
  has_many :items
end