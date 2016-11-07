class Post < ActiveRecord::Base 
  belongs_to :user
  serialize :content
end