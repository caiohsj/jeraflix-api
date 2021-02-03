require 'rest-client'
require 'json'
class Api::V1::ProfilesController < Api::V1::ApiController
    before_action :set_profile, only: [:show, :update, :destroy, :watchlist, :watched_movies, :recommendations]

    before_action :require_authorization!, only: [:show, :update, :destroy, :watchlist, :watched_movies, :recommendations]

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

    def recommendations
        recommendations = []
        recommendations = get_recommendations @profile.watchlist, recommendations
        recommendations = get_recommendations @profile.watched_movies, recommendations
        render json: recommendations
    end

    def watchlist
        movies = get_movies_from_list @profile.watchlist
        render json: {
            profile: @profile,
            movies: movies
        }
    end

    def watched_movies
        movies = get_movies_from_list @profile.watched_movies
        render json: {
            profile: @profile,
            movies: movies
        }
    end

    private
    def get_recommendations(list, recommendations)
        api_key = "3624203c3f8aa66f05b09012ea276ec6"
        list.each do |item|
            urlRecommendations = "https://api.themoviedb.org/3/movie/#{item.movie_id}/recommendations?api_key=#{api_key}"
            responseRecommendation = RestClient.get urlRecommendations
            recommendationsJson = JSON.parse(responseRecommendation)
            results = recommendationsJson['results']
            
            results.each do |rec|
                if recommendations.length == 0
                    recommendations.push rec
                else
                    founded = false
                    i = 0
                    begin
                        if recommendations[i]['id'] == rec['id']
                            founded = true
                        end
                        i += 1
                    end while i < recommendations.length
                    if !founded
                        recommendations.push rec
                    end
                end
            end
        end
        recommendations
    end

    def get_movies_from_list(list)
        api_key = "3624203c3f8aa66f05b09012ea276ec6"
        movies = []
        list.each do |item|
            urlMovie = "https://api.themoviedb.org/3/movie/#{item.movie_id}?api_key=#{api_key}"
            responseMovie = RestClient.get  urlMovie
            movieJson = JSON.parse(responseMovie)
            movies.push movieJson
        end
        movies
    end
    
    def require_authorization!
        unless current_user == @profile.user
            render json: {}, status: :forbidden
        end
    end
end
