class Partner < ApplicationRecord
  validates :id, :trading_name, :owner_name, :document, :coverage_area, :address, presence: true
  validates :id, :document, uniqueness: true
end
