class User < ActiveRecord::Base 
  has_many :post
  serialize :content
  serialize :auth_meta_data
end