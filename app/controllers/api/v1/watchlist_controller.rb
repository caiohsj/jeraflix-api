class Api::V1::WatchlistController < Api::V1::ApiController
    before_action :set_profile, only: [:create]
    before_action :require_authorization!, only: [:create]

 def create
    watchlist = Watchlist.create profile_id: params[:profile_id], movie_id: params[:movie_id]
    render json: watchlist
 end

 def set_profile
    @profile = Profile.find params[:profile_id]
 end

 def require_authorization!
    authorized = false
    current_user.profiles.each do |p|
        if p.id == @profile.id
            authorized = true
        end
    end
    if !authorized
        render json: {}, status: :forbidden
    end
 end
end
