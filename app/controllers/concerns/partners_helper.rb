module PartnersHelper
  extend ActiveSupport::Concern

  BASE_FIELDS = [:id, :trading_name, :owner_name, :document]

  GEO_FIELDS = {coverage_area: 'MultiPolygon', address: 'Point'}

  FIELDS = BASE_FIELDS + GEO_FIELDS.keys

  def missing_base_fields(hash)
    BASE_FIELDS.filter { |key| hash[key].nil?}
  end

  def missing_geo_fields(hash)
    GEO_FIELDS.filter { |key, type| hash[key].nil? || hash[key][:type] != type || hash[key][:coordinates].empty? }.keys
  end

  def filter_parameters(hash)
    basic_partner = hash.slice(*FIELDS)
    GEO_FIELDS.keys.reduce(basic_partner){|acc, key| acc.merge(key => basic_partner[key].slice(:type, :coordinates))}
  end

  def with_valid_parameters(hash)
    parameters = filter_parameters(hash)
    wrong_fields = missing_geo_fields(parameters) + missing_base_fields(parameters)
    unless wrong_fields.empty?
      render json: { invalid_fields: wrong_fields }, status: :bad_request and return
    end
    yield(parameters.permit!)
  end
end
