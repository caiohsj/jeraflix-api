require 'base64'
class Api::V1::UserController < ApplicationController
    def create
        user_exist = User.where email: params[:email]
        if (user_exist.length > 0)
            response = {
                status: false,
                message: 'This email is in use'
            }
        else
            @user = User.new params.permit(:name, :email, :password)
            @user.save
            response = {
                status: true,
                user: @user
            }
        end
        render json: response
    end

    def auth
        password = Base64.decode64(params[:password])
        @user = User.find_for_authentication(email: params[:email])
        if @user.valid_password?(password)
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
