class LogisticLocation < ApplicationRecord
  has_many :inbounds
  has_many :inbound_plans
  belongs_to :product
end
