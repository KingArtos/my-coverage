class PartnerConverter
  FACTORY = RGeo::Cartesian.simple_factory(srid: 4326)
  DECODER = RGeo::GeoJSON

  def self.to_object(request)
    request.slice(*PartnerRequestValidator::BASE_FIELDS).merge({
      coverage_area: DECODER.decode(request[:coverage_area].to_json, json_parser: :json, geo_factory: FACTORY),
      address: DECODER.decode(request[:address].to_json)
    })
  end
end