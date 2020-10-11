class PartnersController < ApplicationController
  include PartnersHelper

  # GET /partners/nearst/-46.57421/-21.785741
  def nearst
    render json: {}
  end

  # GET /partners/1
  def show
    partner = Partner.where(id: params[:id]).first

    if partner
      render json: Representers::PartnerResponse.to_json(partner)
    else
      render json: { error: "Partner not found" }, status: :not_found
    end
  end

  # POST /partners
  def create
    with_valid_parameters(params) do |valid_params|
      partner = Partner.new(PartnerConverter.to_object(valid_params))
      if partner.save
        render json: Representers::PartnerResponse.to_json(partner), status: :created, location: partner
      else
        render json: partner.errors, status: :unprocessable_entity
      end
    end
  end
end
