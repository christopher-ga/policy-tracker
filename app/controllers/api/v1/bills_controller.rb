class Api::V1::BillsController < ApplicationController

  before_action :set_api_key
  def index

  end

  def create
    @bill = Bill.find_or_create_by(bill_id: bill_parameters[:bill_id], bill_type: bill_parameters[:bill_type]) do |bill|
      bill.assign_attributes(bill_parameters)
    end

    if @bill.persisted?
      current_user.user_saved_bills.create(bill: @bill)

      render json: { status: 'success', bill: @bill }, status: :created
    else
      render json: { status: 'error', message: @bill.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def congress_bills
    response = Faraday.get("https://api.congress.gov/v3/bill?api_key=#{@api_key}")
    render json: JSON.parse(response.body)
  end

  def congress_bill
    url = params[:url] + "&api_key=#{@api_key}"
    response = Faraday.get(url)
    render json: JSON.parse(response.body)
  end

  def congress_bills_search
    congress = "118"
    collection_type = "BILLS"
    search_terms = params[:searchTerms]
    query = "collection:#{collection_type} congress:#{congress} #{search_terms}"

    response = Faraday.post("https://api.govinfo.gov/search?api_key=#{@api_key}") do |req|
      req.headers['Content-Type'] = 'application/json'
      req.body = {
        query: query,
        pageSize: 10,
        offsetMark: "*",
        sorts: [
          {
            field: "relevancy",
            sortOrder: "DESC"
          }
        ],
        historical: true,
        resultLevel: "default"
      }.to_json
    end

    if response.success?
      render json: JSON.parse(response.body)
    else
      render json: { error: "Request failed", status: response.status }, status: :unprocessable_entity
    end

  end

  def test_route
    test_bill = {
      firstName: "test",
      fullName: "test",
      party: "test",
      state: "test",
      last_name: "test",
      bioguideId: "Y000064"
    }

    sponsor = fetch_bill_sponsor_information(test_bill)
    render plain: "Sponsor info: #{sponsor}"

  end

  private

  def fetch_bill_sponsor_information(bill)
    sponsor_data = {
      first_name: bill.sponsors.firstName,
      full_title: bill.sponsors.fullName,
      party: bill.sponsors.party,
      state: bill.sponsors.state,
      last_name: bill.sponsors.lastName,
      bioguide_id: bill.sponsors.bioguideId
    }

    url = "https://api.congress.gov/v3/member/#{bill.sponsors[0].bioguideId}?api_key=#{@api_key}"
    response = Faraday.get(url)
    data = JSON.parse(response.body)

    sponsor_data.image_url = data.member.depiction.imageUrl
    sponsor_data.member_type = data.member.terms[-1].memberType

    Sponsor.create(sponsor_data)

    bill_record = Bill.find(bill_id: bill.bill_id)
    BillSponsor.create(bill: bill_record, sponsor: sponsor)

    puts sponsor
    sponsor
  end

  def set_api_key
    @api_key = Rails.application.credentials.congress_api_key
  end

  def bill_parameters
    bill_params = params.require(:bill).permit(
      :id,
      :title,
      :bill_id,
      :introduced_date,
      :update_date,
      :congress,
      :bill_type,
      :bill_url,
      :latest_action,
      :sponsor_first_name,
      :sponsor_last_name,
      :sponsor_party,
      :sponsor_state,
      :sponsor_url
    )
  end

  def sponsor_parameters
    sponsor_params = params.require(:sponsor).permit(
      :id,
      :first_name,
      :last_name,
      :full_title,
      :party,
      :state,
      :bioguide_id,
      :image_url,
      :member_type
    )
  end
end



