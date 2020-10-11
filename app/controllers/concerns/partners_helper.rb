module PartnersHelper
  extend ActiveSupport::Concern

  def validator
    @validator ||= PartnerRequestValidator.new
  end

  def with_valid_parameters(hash)
    parameters = validator.filter_parameters(hash)
    byebug
    invalidations = validator.invalid_fields(parameters) || validator.invalid_coordinates(parameters)
    if invalidations.present?
      render json: invalidations, status: :bad_request and return
    end

    yield(parameters.permit!)
  end
end
