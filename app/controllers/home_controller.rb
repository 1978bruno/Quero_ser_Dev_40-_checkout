class HomeController < ApplicationController
  def index
    redirect_to new_user_session_path if signed_in?.blank?
  end
end
