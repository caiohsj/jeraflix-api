class Api::V1::WatchedMovieController < Api::V1::ApiController
    before_action :set_profile, only: [:create]
    before_action :require_authorization!, only: [:create]

    def create
        profile_id = params[:profile_id];
        movie_id = params[:movie_id]
        foundItem = WatchedMovie.where 'profile_id = :p AND movie_id = :m', { p: profile_id, m: movie_id}
        movie_in_watchlist = Watchlist.where 'profile_id = :p AND movie_id = :m', { p: profile_id, m: movie_id}
        if(foundItem.length > 0)
            Watchlist.destroy movie_in_watchlist[0].id
            response = {
                status: false,
                message: 'This film was watched!'
            }
        else
            watched_movie = WatchedMovie.create profile_id: profile_id, movie_id: movie_id
            if (movie_in_watchlist.length > 0)
                Watchlist.destroy movie_in_watchlist[0].id
                response = {
                    watched_movie: watched_movie,
                    status: true
                }
            else
                response = {
                    status: false,
                    message: "This movie is not on the 'watch later' list"
                }
            end
        end
        render json: response
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
