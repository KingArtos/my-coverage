class Validators::Coordinates
  SUPPORTED_TYPES = ['Point']

  def invalid_coordinates(hash, keys: Partner::GEO_FIELDS.keys)
    invalid_coordinates = filter_invalid_coordinates(hash, keys)
    { invalid_coordinates: invalid_coordinates } unless invalid_coordinates.empty?
  end

  def valid_coordinates?(coordinates)
    lat, long = coordinates
    lat.between?(-90, 90) && long.between?(-180, 180)
  end

  private
    def filter_invalid_coordinates(hash, keys)
      keys.filter { |key| SUPPORTED_TYPES.include?(hash[key][:type]) && !valid_coordinates?(hash[key][:coordinates]) }
    end
end
