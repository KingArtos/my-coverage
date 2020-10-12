class Validators::FilterParams
  def filter_parameters(hash, base_fields: Partner::BASE_FIELDS, geo_fields: Partner::GEO_FIELDS)
    fields = base_fields + geo_fields.keys
    basic_partner = hash.slice(*fields)

    geo_fields.keys.reduce(basic_partner){|acc, key|
      acc.merge(key => basic_partner[key].slice(:type, :coordinates))
    }
  end
end
