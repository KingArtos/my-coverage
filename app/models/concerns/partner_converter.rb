class PartnerConverter
  DECODER = RGeo::GeoJSON

  def self.to_object(request)
    request.slice(*PartnersHelper::BASE_FIELDS).merge({
      coverage_area: DECODER.decode(request[:coverage_area].to_json),
      address: DECODER.decode(request[:address].to_json)
    })
  end
end