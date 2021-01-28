class Api::V1::UserController < ApplicationController
    def create
        @user = User.new params.permit(:name, :email, :password)
        @user.save
        render json: @user
    end

    def auth
        
        @user = User.find_for_authentication(email: params[:email])
        if @user.valid_password?(params[:password])
            render json: {
                name: @user.name,
                email: @user.email,
                token: @user.authentication_token
            }
        end
        
    end

    def show_profiles
        @profiles = current_user.profiles

        render json: @profiles
    end
end
