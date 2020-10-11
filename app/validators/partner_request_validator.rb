class PartnerRequestValidator
  BASE_FIELDS = [:id, :trading_name, :owner_name, :document]

  GEO_FIELDS = {coverage_area: 'MultiPolygon', address: 'Point'}

  TYPES_WITH_COORDINATES = ['Point']

  FIELDS = BASE_FIELDS + GEO_FIELDS.keys

  def filter_parameters(hash)
    basic_partner = hash.slice(*FIELDS)
    GEO_FIELDS.keys.reduce(basic_partner){|acc, key| acc.merge(key => basic_partner[key].slice(:type, :coordinates))}
  end

  def invalid_fields(hash)
    invalid_fields = missing_geo_fields(hash) + missing_base_fields(hash)
    { invalid_fields: invalid_fields } unless invalid_fields.empty?
  end

  def invalid_coordinates(hash)
    invalid_coordinates = filter_invalid_coordinates(hash)
    { invalid_coordinates: invalid_coordinates } unless invalid_coordinates.empty?
  end

  def valid_coordinates?(coordinates)
    lat, long = coordinates
    lat.between?(-90, 90) && long.between?(-180, 180)
  end

  private
    def missing_base_fields(hash)
      BASE_FIELDS.filter { |key| hash[key].nil?}
    end

    def missing_geo_fields(hash)
      GEO_FIELDS.filter { |key, type| hash[key].nil? || hash[key][:type] != type || hash[key][:coordinates].empty? }.keys
    end

    def filter_invalid_coordinates(hash)
      GEO_FIELDS.filter { |key, type| TYPES_WITH_COORDINATES.include?(type) &&
        !valid_coordinates?(hash[key][:coordinates]) }.keys
    end
end