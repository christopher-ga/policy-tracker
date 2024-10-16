class PagesController < ApplicationController
  layout false, only: [:landing_page]
  before_action :require_sign_in, :set_current_user , except: [:landing_page]
  def require_sign_in
    unless current_user
      redirect_to landing_url
    end
  end
  def stub_page
  end

  def landing_page
    if current_user
      redirect_to root_path
    end
  end

  def my_bills_page
    @on_bills =true
  end

  def home_page
    @on_home = true
  end

  def search_page
    @on_search = true
  end

  private

  def set_current_user
    if current_user
      @user = current_user
    end
  end

end
