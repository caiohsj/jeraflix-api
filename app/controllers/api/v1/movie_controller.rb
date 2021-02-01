require 'rest-client'
require 'json'
class Api::V1::MovieController < Api::V1::ApiController
    def show
        id = params[:id].to_i
        profile_id = params[:profile].to_i
        api_key = "3624203c3f8aa66f05b09012ea276ec6"
        url = "https://api.themoviedb.org/3/movie/#{id}?api_key=#{api_key}"
        begin movie = JSON.parse RestClient.get url
            response = {
                status: true,
                movie: movie
            }
            movie_in_watchlist = Watchlist.where movie_id: movie["id"], profile_id: profile_id
            movie_in_watched_movies = WatchedMovie.where movie_id: movie["id"], profile_id: profile_id

            response["movie_in_watchlist"] = false
            response["movie_in_watched_movies"] = false
            if (movie_in_watchlist.length > 0)
                response["movie_in_watchlist"] = true
            end
            if (movie_in_watched_movies.length > 0)
                response["movie_in_watched_movies"] = true
            end
        rescue Exception => e
            response = {
                status: false,
                message: e.message
            }
        end
        render json: response
    end
end
