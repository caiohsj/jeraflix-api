class Api::V1::ProfilesController < Api::V1::ApiController
    before_action :set_profile, only: [:show, :update, :destroy]

    before_action :require_authorization!, only: [:show, :update, :destroy]

    def index
        render json: current_user.profiles
    end

    def create
        if (current_user.profiles.length < 4)
            @profile = current_user.profiles.new params.permit(:name)
            @profile.save
            render json: @profile
        else
            render json: {
                status: false,
                message: 'You cannot have more than one profile.'
            }, status: :forbidden
        end
    end

    def set_profile
        @profile = Profile.find params[:id]
    end

    def show
        render json: @profile
    end
    
    def require_authorization!
        unless current_user == @profile.user
            render json: {}, status: :forbidden
        end
    end
end
