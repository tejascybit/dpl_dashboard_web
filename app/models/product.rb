class Product < ApplicationRecord
  has_many :tanks
  has_many :inventories
  has_many :productions
  has_many :production_plans
  #has_many :logistic_locations
  has_many :inbounds
  has_many :inbound_plans
  has_many :sales_outbounds
end
