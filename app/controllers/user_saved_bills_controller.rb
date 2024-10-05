class UserSavedBillsController < ApplicationController

  def index
    @saved_bills = current_user.bills
    render json: @saved_bills, status: :ok
  end

end
