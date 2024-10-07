class PagesController < ApplicationController
  layout false, only: [:landing_page]
  before_action :require_sign_in, except: [:landing_page]

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

end
