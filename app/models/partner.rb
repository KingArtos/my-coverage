class Partner < ApplicationRecord
  validates :id, :trading_name, :owner_name, :document, :coverage_area, :address, presence: true
  validates :id, :document, uniqueness: true

  scope :nearst_in_coverage_by_point, -> (point) {
    where("ST_INTERSECTS(coverage_area, GeomFromEWKT('SRID=4326; #{point}'))")
      .order(Arel.sql("ST_DISTANCE(address, GeomFromEWKT('SRID=4326; #{point}'))"))
      .limit(1)
  }
end
