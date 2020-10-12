module PartnersHelper
  extend ActiveSupport::Concern

  def coordinates_validator
    @coordinates_validator ||= Validators::Coordinates.new
  end

  def missing_fields_validator
    @missing_fields_validator ||= Validators::MissingFields.new
  end

  def filter_params_validator
    @filter_params_validator ||= Validators::FilterParams.new
  end

  def with_valid_coordinates(lat, long)
    unless coordinates_validator.valid_coordinates?([lat, long])
      render json: {invalid_coordinates: [lat, long]}, status: :bad_request and return
    end
    yield(lat, long)
  end

  def with_valid_parameters(hash)
    parameters = filter_params_validator.filter_parameters(hash)
    invalidations = missing_fields_validator.invalid_fields(parameters) ||
      coordinates_validator.invalid_coordinates(parameters)

    if invalidations.present?
      render json: invalidations, status: :bad_request and return
    end
    yield(parameters.permit!)
  end
end
