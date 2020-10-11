class Representers::PartnerResponse
  BASE_FIELDS = [:id, :trading_name, :owner_name, :document]
  GEO_FIELDS = [:address, :coverage_area]

  def self.to_json(partner)
    BASE_FIELDS.reduce({}){ |acc, key|
      acc.merge(key => partner[key])
    }.merge(PartnerConverter.geo_fields_encode(partner, GEO_FIELDS)).to_json
  end
end
