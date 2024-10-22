class Api::V1::UserSavedBillsController < ApplicationController

  def index
    @saved_bills = current_user.bills.includes(:sponsors)



    bills_with_sponsors = @saved_bills.map do |bill|
      last_view = UserBillView.find_by(user: current_user, bill: bill)

      changed = if last_view
                  bill.update_date > last_view.last_viewed_at
                else
                  true
                end

      tracking_count = UserSavedBill.where(bill: bill).count


      bill.as_json(include: :sponsors).merge(saved: true, changed: changed, tracking_count: tracking_count)
    end

    render json: bills_with_sponsors, status: :ok
  end

  def create
    bill = Bill.find_by(package_id: params[:package_id])

    if bill.nil?
      render json: {error: "Bill not found"}, status: :not_found
      return
    end

    UserBillView.find_or_create_by(user: current_user, bill: bill).update(last_viewed_at: Time.current)
    saved_bill = current_user.user_saved_bills.find_or_create_by(bill: bill)

    if saved_bill.persisted?
      render json: { message: "Bill saved successfully", bill: bill }, status: :created
    else
      render json: { error: "Failed to save bill" }, status: :unprocessable_entity
    end
  end

  def destroy
    bill = Bill.find_by(package_id: params[:package_id])

    if bill.nil?
      render json: { error: "Bill not found" }, status: :not_found
      return
    end

    saved_bill = current_user.user_saved_bills.find_by(bill: bill)

    if saved_bill
      saved_bill.destroy
      UserBillView.find_by(user: current_user, bill: bill)&.destroy
      render json: { message: "Bill untracked successfully" }, status: :ok
    else
      render json: { error: "Bill not tracked by user" }, status: :not_found
    end
  end

end
