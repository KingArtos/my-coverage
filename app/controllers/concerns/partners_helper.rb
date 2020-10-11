module PartnersHelper
  extend ActiveSupport::Concern

  def validator
    @validator ||= PartnerRequestValidator.new
  end

  def with_valid_coordinates(lat, long)
    unless validator.valid_coordinates?([lat, long])
      render json: {invalid_coordinates: [lat, long]}, status: :bad_request and return
    end
    yield(lat, long)
  end

  def with_valid_parameters(hash)
    parameters = validator.filter_parameters(hash)
    invalidations = validator.invalid_fields(parameters) || validator.invalid_coordinates(parameters)
    if invalidations.present?
      render json: invalidations, status: :bad_request and return
    end

    yield(parameters.permit!)
  end
end
