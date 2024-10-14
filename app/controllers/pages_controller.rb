class PagesController < ApplicationController
  layout false, only: [:landing_page]
  before_action :require_sign_in, except: [:landing_page, :home_page, :search_page]

  def require_sign_in
    unless current_user
      redirect_to landing_url
    end
  end
  def stub_page

  end

  def landing_page
    @user = User.new
    if current_user
      redirect_to root_path
    end
  end

  def home_page

  end

  def search_page

  end

end
