class InboundPlan < ApplicationRecord
  belongs_to :product
  belongs_to :logistic_location

end
