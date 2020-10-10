class PartnersController < ApplicationController
  before_action :set_partner, only: [:show]
  before_action :set_nearst, only: [:nearst]

  # GET /partners/nearst/-46.57421/-21.785741
  def nearst
    render json: @partner
  end

  # GET /partners/1
  def show
    render json: @partner
  end

  # POST /partners
  def create
    @partner = Partner.new(partner_params)

    if @partner.save
      render json: @partner, status: :created, location: @partner
    else
      render json: @partner.errors, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_partner
      @partner = Partner.find(params[:id])
    end

    def set_nearst
      @partner = Partner.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def partner_params
      params.fetch(:partner, {})
    end
end
