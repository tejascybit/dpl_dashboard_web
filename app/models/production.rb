class Production < ApplicationRecord
  belongs_to :product
  enum localization: [:DT, :UT, :QTY, :RATE]
end
