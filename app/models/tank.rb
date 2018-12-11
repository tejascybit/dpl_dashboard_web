class Tank < ApplicationRecord
  has_many :inventories
  belongs_to :product
end
