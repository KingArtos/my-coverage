class PartnersController < ApplicationController
  include PartnersHelper

  # GET /partners/nearst/-46.57421/-21.785741
  def nearst
    with_valid_coordinates(params[:lat].to_f, params[:long].to_f) do |lat, long|
      point = PartnerConverter.to_point(lat, long)
      partner = Partner.nearst_in_coverage_by_point(point)
      render_find_flow(partner.first)
    end
  end

  # GET /partners/1
  def show
    render_find_flow(Partner.where(id: params[:id]).first)
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

  private
    def render_find_flow(partner)
      if partner
        render json: Representers::PartnerResponse.to_json(partner)
      else
        render json: { error: "Partner not found" }, status: :not_found
      end
    end
end
