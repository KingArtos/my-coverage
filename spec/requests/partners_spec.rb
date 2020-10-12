require 'rails_helper'

RSpec.describe "/partners", type: :request do
  let(:valid_partner) {
    {
      "id": 1,
      "tradingName": "Adega Osasco",
      "ownerName": "Ze da Ambev",
      "document": "02.453.716/000170",
      "coverageArea": {
         "type": "MultiPolygon",
         "coordinates": [
            [
               [
                  [
                     -43.36,
                     -22.30
                  ],
                  [
                     -44.37,
                     -23.30
                  ],
                  [
                     -43.98,
                     -23.60
                  ],
                  [
                     -43.36,
                     -22.30
                  ]
               ]
            ]
         ]
      },
      "address": {
         "type": "Point",
         "coordinates": [
            -43.79,
            -22.70
         ]
      }
    }
  }

  let(:valid_partner_nearst) {
    {
      "id": 2,
      "tradingName": "Adega Osasco",
      "ownerName": "Ze da Ambev",
      "document": "01.390.716/000170",
      "coverageArea": {
         "type": "MultiPolygon",
         "coordinates": [
            [
               [
                  [
                     -43.36,
                     -22.30
                  ],
                  [
                     -44.37,
                     -23.30
                  ],
                  [
                     -43.98,
                     -23.60
                  ],
                  [
                     -43.36,
                     -22.30
                  ]
               ]
            ]
         ]
      },
      "address": {
         "type": "Point",
         "coordinates": [
            -43.85,
            -22.70
         ]
      }
    }
  }

  let(:inside_user_point) {
    {
      lat: -43.98,
      long: -23.59
    }
  }

  let(:outside_user_point) {
    {
      lat: -43.99,
      long: -23.59
    }
  }

  describe "GET /nearst" do
    before do
      [valid_partner, valid_partner_nearst].each do |partner|
        post partners_url, params: partner, as: :json
      end
    end

    it "renders a successful response" do
      get "/partners/nearst/#{inside_user_point[:lat]}/#{inside_user_point[:long]}", as: :json
      expect(response).to be_successful
      expect(JSON.parse(response.body)).to eq(stringify_hash(valid_partner_nearst))
    end
  end

  describe "GET /show" do
    before { post partners_url, params: valid_partner, as: :json }

    context "included id" do
      it "renders a successful response" do
        get partner_url(valid_partner[:id]), as: :json
        expect(response).to be_successful
        expect(JSON.parse(response.body)).to eq(stringify_hash(valid_partner))
      end
    end

    context "not included id" do
      let(:not_included_id) { valid_partner[:id] + valid_partner_nearst[:id] }

      it "renders not found a successful response" do
        get partner_url(not_included_id), as: :json
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Partner" do
        expect {
          post partners_url,
               params: valid_partner, as: :json
        }.to change(Partner, :count).by(1)
      end

      it "renders a JSON response with the new partner" do
        post partners_url,
             params: valid_partner, as: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including("application/json; charset=utf-8"))
      end
    end

    context "to included partner" do
      before { post partners_url, params: valid_partner, as: :json }

      it "does not create a new Partner" do
        expect {
          post partners_url,
               params: valid_partner, as: :json
        }.to change(Partner, :count).by(0)
      end

      it "renders a JSON response with errors for the duplicated partner" do
        post partners_url,
             params: valid_partner, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq("application/json; charset=utf-8")
      end
    end

    context "with invalid parameters" do
      let(:invalid_partner) {
        valid_partner.merge(
          {
            "address": {
               "type": "Point",
               "coordinates": [
                  -90.85,
                  -22.70
               ]
            }
          }
        )
      }

      it "does not create a new Partner" do
        expect {
          post partners_url,
               params: invalid_partner, as: :json
        }.to change(Partner, :count).by(0)
      end

      it "renders a JSON response with errors for the new partner" do
        post partners_url,
             params: invalid_partner, as: :json
        expect(response).to have_http_status(:bad_request)
        expect(response.content_type).to eq("application/json; charset=utf-8")
      end
    end
  end

  def stringify_hash(h)
    h.deep_transform_keys(&:to_s)
  end
end
