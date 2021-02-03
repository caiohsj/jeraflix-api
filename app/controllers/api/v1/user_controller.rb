require 'base64'
class Api::V1::UserController < ApplicationController
    def create
        @user = User.new params.permit(:name, :email, :password)
        if @user.save
            response = {
                status: true,
                user: @user
            }
            status = :ok
        else
            response = {
                status: false,
                message: @user.errors['email'][1]
            }
            status = :unprocessable_entity
        end
        render json: response, status: status
    end

    def auth
        password = Base64.decode64(params[:password])
        @user = User.find_for_authentication(email: params[:email])
        if @user.valid_password?(password)
            response = {
                name: @user.name,
                email: @user.email,
                token: @user.authentication_token
            }
            status = :ok
        else
            response = {
                status: false,
                message: 'Credentials is incorrect'
            }
            status = :unauthorized
        end
        render json: response, status: status
    end

    def show_profiles
        @profiles = current_user.profiles

        render json: @profiles
    end
end
