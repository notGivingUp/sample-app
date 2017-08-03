class AccountActivationsController < ApplicationController
  attr_reader :user

  def edit
    @user = User.find_by email: params[:email]
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      active_success
    else
      flash[:danger] = t "mail.invalid_link"
      redirect_to root_url
    end
  end

  private

  def active_success
    user.activate
    log_in user
    flash[:success] = t "mail.activated"
    redirect_to user
  end
end
