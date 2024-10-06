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


  private

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

end



