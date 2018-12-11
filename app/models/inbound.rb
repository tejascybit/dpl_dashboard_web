class Inbound < ApplicationRecord
  belongs_to :product
  belongs_to :logistic_locations

end
