require 'rest-client'
require 'json'
class Api::V1::ProfilesController < Api::V1::ApiController
    before_action :set_profile, only: [:show, :update, :destroy, :watchlist]

    before_action :require_authorization!, only: [:show, :update, :destroy]

    def index
        render json: current_user.profiles
    end

    def create
        if (current_user.profiles.length < 4)
            @profile = current_user.profiles.new params.permit(:name)
            @profile.save
            response = @profile
            status = :ok
        else
            response = {
                status: false,
                message: 'You cannot have more than one profile.'
            }
            status = :forbidden
        end

        render json: response, status: status
    end

    def set_profile
        @profile = Profile.find params[:id]
    end

    def show
        render json: @profile
    end

    def watchlist
        @movies = []
        @profile.watchlist.each do |item|
            response = RestClient.get 'https://api.themoviedb.org/3/movie/464052?api_key=3624203c3f8aa66f05b09012ea276ec6'
            movie = JSON.parse(response)
            @movies.push movie
        end

        render json: {
            profile: @profile,
            movies: @movies
        }
    end
    
    def require_authorization!
        unless current_user == @profile.user
            render json: {}, status: :forbidden
        end
    end
end
