class Validators::MissingFields
  def invalid_fields(hash, base_fields: Partner::BASE_FIELDS, geo_fields: Partner::GEO_FIELDS)
    invalid_fields = missing_geo_fields(hash, geo_fields) +
      missing_base_fields(hash, base_fields)
    { invalid_fields: invalid_fields } unless invalid_fields.empty?
  end

  private
    def missing_base_fields(hash, base_fields)
      base_fields.filter { |key| hash[key].nil?}
    end

    def missing_geo_fields(hash, geo_fields)
      geo_fields.filter { |key, type|
        hash[key].nil? || hash[key][:type] != type || hash[key][:coordinates].empty?
      }.keys
    end
end
