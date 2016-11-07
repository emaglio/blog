class User < ActiveRecord::Base 
  has_many :post
  serialize :content
end