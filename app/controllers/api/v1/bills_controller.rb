class Api::V1::BillsController < ApplicationController

  before_action :set_api_key, :set_current_user
  def index

  end

  def show
    bill = Bill.find_by(package_id: params[:id])

    if bill.nil?
      render json: { error: 'Bill not found' }, status: :not_found and return
    end

    user_saved_bill = current_user.user_saved_bills.find_by(bill: bill)

    if user_saved_bill
      user_bill_view = UserBillView.find_or_initialize_by(user: current_user, bill: bill)
      user_bill_view.update(last_viewed_at: Time.current)
      @view = user_bill_view.last_viewed_at
    end

    @bill = bill
    @saved = user_saved_bill.present?

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

  def gov_search
    congress = "118"
    collection_type = "BILLS"
    search_terms = params[:searchTerms]
    sort_order = params[:sortOrder]

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
            sortOrder: sort_order
          }
        ],
        historical: true,
        resultLevel: "default"
      }.to_json
    end

    unless response.success?
      render json: { error: "Request failed", status: response.status }, status: :unprocessable_entity and return
    end

    data = JSON.parse(response.body, symbolize_names: true)
    bills_from_api = data[:results]

    saved_user_bills = current_user.user_saved_bills.joins(:bill).pluck('bills.package_id')

    bills = []

    bills_from_api.each do |bill_data|
      package_id = bill_data[:packageId]
      existing_bill = Bill.find_by(package_id: package_id)

      if saved_user_bills.include?(package_id) && existing_bill
        last_view = UserBillView.find_by(user: current_user, bill: existing_bill)

        changed = if last_view
                    existing_bill.update_date > last_view.last_viewed_at
                  else
                    true
                  end

        tracking_count = UserSavedBill.where(bill: existing_bill).count


        bills << existing_bill.as_json(include: :sponsors)
                              .merge(saved: true, changed: changed,  tracking_count: tracking_count)

      else

        bill = existing_bill || fetch_bill_details(bill_data)
        tracking_count = Bill.exists?(package_id: package_id) ? UserSavedBill.where(bill: bill).count : 0

        bills << bill.as_json(include: :sponsors).merge(saved: false,  tracking_count: tracking_count)
      end
    end

    render json: bills

  end
  def gov_collection

    existing_bill_197 = Bill.find_by(id: 197)
    puts "Bill with ID 197 fetched: #{existing_bill_197.inspect}" if existing_bill_197

    api_url = "https://api.govinfo.gov/collections/BILLS/2018-01-28T20%3A18%3A10Z?offset=0&pageSize=10&api_key=#{@api_key}"

    response = Faraday.get(api_url)

    unless response.success?
      render json: { error: "Request failed", status: response.status }, status: :unprocessable_entity and return
    end

    data = JSON.parse(response.body, symbolize_names: true)
    bills_from_api = data[:packages]

    bills = []

    saved_user_bills = current_user.user_saved_bills.joins(:bill).pluck('bills.package_id')

    bills_from_api.each do |bill_data|
      package_id = bill_data[:packageId]
      existing_bill = Bill.find_by(package_id: package_id)

      if saved_user_bills.include?(package_id) && existing_bill
        # update_bill_with_latest_action(existing_bill) - commented out for demonstration purposes
        last_view = UserBillView.find_by(user: current_user, bill: existing_bill)
        changed = if last_view
                    existing_bill.update_date > last_view.last_viewed_at
                  else
                    true
                  end


        tracking_count = UserSavedBill.where(bill: existing_bill).count - 1

        bills << existing_bill.as_json(include: :sponsors)
                              .merge(saved: true, changed: changed,  tracking_count: tracking_count)

      else

        bill = existing_bill || fetch_bill_details(bill_data)
        tracking_count = Bill.exists?(package_id: package_id) ? UserSavedBill.where(bill: bill).count : 0

        bills << bill.as_json(include: :sponsors).merge(saved: false,  tracking_count: tracking_count)
      end
    end

    render json: bills
  end


  private

  def set_api_key
    @api_key = Rails.application.credentials.congress_api_key
  end

  def fetch_bill_details(bill_data)
    api_key = @api_key
    package_id = bill_data[:packageId]

    bill = Bill.new(
      package_id: package_id,
      update_date: bill_data[:lastModified],
      congress: bill_data[:congress],
      date_issued: bill_data[:dateIssued],
      short_title: bill_data[:title]
    )

    summary_url = "https://api.govinfo.gov/packages/#{package_id}/summary?api_key=#{api_key}"
    summary_response = Faraday.get(summary_url)
    summary_data = JSON.parse(summary_response.body, symbolize_names: true)

    bill.bill_number = summary_data[:billNumber]
    bill.title = summary_data[:title]
    bill.bill_type = summary_data[:billType]

    latest_action_url = "https://api.congress.gov/v3/bill/118/#{bill.bill_type}/#{bill.bill_number}?api_key=#{api_key}"
    latest_action_response = Faraday.get(latest_action_url)
    latest_action_data = JSON.parse(latest_action_response.body, symbolize_names: true)

    puts "LOOK HERE", latest_action_data
    bill.latest_action_date = latest_action_data.dig(:bill, :latestAction, :actionDate)
    bill.latest_action_text = latest_action_data.dig(:bill, :latestAction, :text)

    if summary_data[:members]&.any?
      member_data = summary_data[:members].first
      sponsor = process_sponsor(member_data)
      bill.sponsors << sponsor unless bill.sponsors.include?(sponsor)
    end

    bill.save
    bill
  end

  def process_sponsor(member_data)
    api_key = @api_key
    bio_guide_id = member_data[:bioGuideId]
    sponsor = Sponsor.find_by(bio_guide_id: bio_guide_id)

    unless sponsor
      sponsor = Sponsor.new(
        state: member_data[:state],
        party: member_data[:party],
        bio_guide_id: bio_guide_id,
        full_title: member_data[:fullName]
      )

      sponsor_url = "https://api.congress.gov/v3/member/#{bio_guide_id}?format=json&api_key=#{api_key}"
      sponsor_response = Faraday.get(sponsor_url)
      sponsor_data = JSON.parse(sponsor_response.body, symbolize_names: true)

      sponsor.image_url = sponsor_data.dig(:member, :depiction, :imageUrl)
      sponsor.first_name = sponsor_data.dig(:member, :firstName)
      sponsor.last_name = sponsor_data.dig(:member, :lastName)
      sponsor.save
    end

    sponsor
  end

  def set_current_user
    if current_user
      @user = current_user
    end
  end

  def update_bill_with_latest_action(bill)
    latest_action_url = "https://api.congress.gov/v3/bill/118/#{bill.bill_type}/#{bill.bill_number}?api_key=#{@api_key}"
    latest_action_response = Faraday.get(latest_action_url)

    if latest_action_response.success?
      latest_action_data = JSON.parse(latest_action_response.body, symbolize_names: true)
      bill.update(
        latest_action_date: latest_action_data.dig(:bill, :latestAction, :actionDate),
        latest_action_text: latest_action_data.dig(:bill, :latestAction, :text)
      )
      bill.update_date = bill.latest_action_date
      bill.save
    else
      Rails.logger.warn("Failed to fetch latest action for bill #{bill.package_id}")
    end
  end

end
