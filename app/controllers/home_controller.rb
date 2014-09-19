class HomeController < ApplicationController
  def index
    if user_signed_in? 
      redirect_to team_path(current_user.current_team_id) if current_user.current_team_id.present?
    end
  end
end