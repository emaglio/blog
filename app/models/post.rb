class Post < ActiveRecord::Base 
  belongs_to :user
  serialize :content, Array
  has_many :items
  accepts_nested_attributes_for :items, allow_destroy: true
end