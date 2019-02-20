class SessionsController < ApplicationController
    before_action :authentication, only: [:destroy]

    def index
    end

    def create # Creates new session / login
        user = User.find_by(username: params[:session][:username])

        if user&.authenticate(params[:session][:password])
            cookies[:token] = user.token
        end

        redirect_to '/'
    end

    def destroy # Destroys the session / logout
        current_user.regenerate_token if logged_in
        cookies.delete(:token)

        redirect_to '/'
    end
end
