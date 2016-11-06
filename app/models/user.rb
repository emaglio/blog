class User < ActiveRecord::Base 
  has_many :post
end