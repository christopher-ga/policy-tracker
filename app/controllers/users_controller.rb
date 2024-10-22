class UsersController < ApplicationController

  def index
    @user = User.all
  end
  def new
  @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    puts params.inspect
    @user = User.create(user_params)

    if @user.save
      session[:user_id] = @user.id
      redirect_to root_path, notice: "Welcome back, #{@user.email}!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    session[:user_id] = nil
    redirect_to users_url, status: :see_other, alert: "Account deleted"
  end

  private

  def user_params
    params.permit(:email, :password, :password_confirmation)
  end

end

